library Position {
    struct Info {
        uint128 liquidity;
    }

    function get(
        mapping(bytes32 => Info) storage self,
        address owner,
        int24 lowTick,
        int24 upTick
    ) internal view returns (Position.Info storage position) {
        position = self[
            keccak256(abi.encodePacked(owner, lowTick, upTick))
        ];
        }

    function update(Info storage self, uint128 liqDelta) internal {
        uint128 liqBefore = self.liquidity;
        uint128 liqAfter = liqBefore + liqDelta;

        self.liquidity = liqAfter;
    }
}
