module abcd::qwert {
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    struct RiseInNFT has key, store {
        id: UID,
        name: string::String,
    }

    struct MintNFT has copy, drop {
        object_id: ID,
        creator: address,
        name: string::String,
    }

    /// yeni nft olustur
    public entry fun mint(
        name: vector<u8>,
        ctx: &mut TxContext
    ) {
        let nft = RiseInNFT {
            id: object::new(ctx),
            name: string::utf8(name),
        };
        let sender = tx_context::sender(ctx);
        event::emit(MintNFT {
            object_id: object::uid_to_inner(&nft.id),
            creator: sender,
            name: nft.name,
        });
        transfer::public_transfer(nft, sender);
    }

    /// nft yak
    public entry fun burn(nft: RiseInNFT) {
        let RiseInNFT { id, name: _} = nft;
        object::delete(id)
    }

    /// nft adini al
    public fun name(nft: &RiseInNFT): &string::String {
        &nft.name
    }

}
