library Tick {
    struct Info {
        bool initialized;
        uint128 liquidity;
    }

    function update(
        mapping(int24 => Tick.Info) storage self,
        int24 tick,
        uint128 liqDelta
    ) internal {
        Tick.Info storage _tick = self[tick];
        uint128 liqBefore = _tick.liquidity;
        uint128 liqAfter = liqBefore + liqDelta;

        if (liqBefore == 0) {
            tickInfo.initialized = true;
        }

        _tick.liquidity = liqAfter;
    }
}
