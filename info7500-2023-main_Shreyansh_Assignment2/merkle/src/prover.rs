use crate::util::{Hash32Bytes, write_merkle_proof,encode_hash,hash_internal, MerkleProof, hash_leaf};

fn gen_leaves_for_merkle_tree(num_leaves: usize) -> Vec<String> {
    let leaves: Vec<String> = (0..num_leaves)
        .map(|i| format!("data item {}", i))
        .collect();

    println!("\nI generated #{} leaves for a Merkle tree.", num_leaves);

    leaves
}

fn hexs(v: Hash32Bytes) -> String {
    let h = hex::encode(v);
    return h.chars().take(4).collect()
}

pub fn gen_merkle_proof(leaves: Vec<String>, leaf_pos: usize) -> Vec<Hash32Bytes> {
    let height = (leaves.len() as f64).log2().ceil() as u32;
    let padlen = (2u32.pow(height)) as usize - leaves.len();

    // hash all the leaves
    let mut state: Vec<Hash32Bytes> = leaves.into_iter().map(hash_leaf).collect();

    // Pad the list of hashed leaves to a power of two
    let zeros = [0u8; 32];
    for _ in 0..padlen {
        state.push(zeros);
    }

    for (index, value) in state.iter().enumerate() {
        println!("{}: {}", index, hexs(*value));
    }

    // initialize a vector that will contain the hashes in the proof
    let mut hashes: Vec<Hash32Bytes> = vec![];

    let mut level_pos = leaf_pos;
    for level in 0..height {
    // Calculate the index of the sibling node
    let sibling_pos = if level_pos % 2 == 0 { level_pos + 1 } else { level_pos - 1 };
    // Add the sibling's hash to the proof if the sibling index is within the current level's range
    if sibling_pos < state.len() {
        hashes.push(state[sibling_pos]);
    }
    // Update the level_pos for the next level up in the tree
    level_pos = level_pos / 2;
    // After each level, the state needs to be updated to represent the parent nodes at the next level
    let mut next_level_state = Vec::new();
    for i in (0..state.len()).step_by(2) {
        // Ensure we do not go out of bounds
        if i + 1 < state.len() {
            // Combine the two child nodes to form the parent node and hash them
            let parent_hash = hash_internal(state[i], state[i + 1]);
            next_level_state.push(parent_hash);
        } else {
            // If there is an odd number of nodes, the last one goes up unpaired
            next_level_state.push(state[i]);
        }
    }
    // Update the state to be the newly formed level of parent nodes
    state = next_level_state;
}


    // Returns list of hashes that make up the Merkle Proof
    hashes
}

pub fn run(leaf_position: usize, num_leaves: usize) {
    let file_name = format!("proof_gen_{}_{}.yaml", num_leaves, leaf_position);

    let leaves = gen_leaves_for_merkle_tree(num_leaves);
    assert!(leaf_position < leaves.len());
    let leaf_value = leaves[leaf_position].clone();
    let hashes = gen_merkle_proof(leaves, leaf_position);

    let mut proof_hash_values_base64: Vec<String> = Vec::new();

    for hash in hashes {
        proof_hash_values_base64.push(encode_hash(hash))
    }

    let proof = MerkleProof{
        leaf_position,
        leaf_value,
        proof_hash_values_base64,
        proof_hash_values: None,
    };

    write_merkle_proof(&proof, &file_name)
}