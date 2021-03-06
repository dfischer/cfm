{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE ViewPatterns #-}

module RTL.Shifter where

import Clash.Prelude

import CFM.Types
import RTL.Common.Bits (revbits)

leftShift :: Cell -> BitVector 4 -> Cell
leftShift input d = revbits $ rightShift (revbits input) d

rightShift :: Cell -> BitVector 4 -> Cell
rightShift input (unpack -> (s3, s2, s1, s0)) = mux1
  where
    mux1 = if s0 then zeroExtend (slice d15 d1 mux2) else mux2
    mux2 = if s1 then zeroExtend (slice d15 d2 mux4) else mux4
    mux4 = if s2 then zeroExtend (slice d15 d4 mux8) else mux8
    mux8 = if s3 then zeroExtend (slice d15 d8 input) else input
