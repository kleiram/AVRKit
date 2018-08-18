import Foundation

class Decoder {
    typealias Handler = (_: UInt16, _: Core) -> Void
    typealias Instruction = (String, UInt16, UInt16, Handler)

    private var instructions: [Instruction]

    init() {
        self.instructions = []

        [
            ("add", 0xfc00, 0x0c00, self._add),
            ("adc", 0xfc00, 0x1c00, self._adc),
            ("adiw", 0xff00, 0x9600, self._adiw),
            ("sub", 0xfc00, 0x1800, self._sub),
            ("subi", 0xf000, 0x5000, self._subi),
            ("sbc", 0xfc00, 0x0800, self._sbc),
            ("sbci", 0xf000, 0x4000, self._sbci),
            ("sbiw", 0xff00, 0x9700, self._sbiw),
            ("and", 0xfc00, 0x2000, self._and),
            ("andi", 0xf000, 0x7000, self._andi),
            ("or", 0xfc00, 0x2800, self._or),
            ("ori", 0xf000, 0x6000, self._ori),
            ("eor", 0xfc00, 0x2400, self._eor),
            ("com", 0xfe0f, 0x9400, self._com),
            ("neg", 0xfe0f, 0x9401, self._neg),
            ("inc", 0xfe0f, 0x9403, self._inc),
            ("dec", 0xfe0f, 0x940a, self._dec),
            ("ser", 0xff0f, 0xef0f, self._ser),
            ("mul", 0xfc00, 0x9c00, self._mul),
            ("muls", 0xff00, 0x0200, self._muls),
            ("mulsu", 0xff88, 0x0300, self._mulsu),
            ("fmul", 0xff88, 0x0308, self._fmul),
            ("fmuls", 0xff88, 0x0380, self._fmuls),
            ("fmulsu", 0xff88, 0x0388, self._fmulsu),
            ("mov", 0xfc00, 0x2c00, self._mov),
            ("movw", 0xff00, 0x0100, self._movw),
            ("ldi", 0xf000, 0xe000, self._ldi),
            ("lds", 0xfe0f, 0x9000, self._lds),
            ("ld", 0xfe0f, 0x900c, self._ld),
            ("ld", 0xfe0f, 0x900d, self._ld),
            ("ld", 0xfe0f, 0x900e, self._ld),
            ("ld", 0xfe0f, 0x8008, self._ld),
            ("ld", 0xfe0f, 0x9009, self._ld),
            ("ld", 0xfe0f, 0x900a, self._ld),
            ("ld", 0xfe0f, 0x8000, self._ld),
            ("ld", 0xfe0f, 0x9001, self._ld),
            ("ld", 0xfe0f, 0x9002, self._ld),
            ("ldd", 0xd208, 0x8008, self._ldd),
            ("ldd", 0xd208, 0x8000, self._ldd),
            ("sts", 0xfe0f, 0x9200, self._sts),
            ("st", 0xfe0f, 0x920c, self._st),
            ("st", 0xfe0f, 0x920d, self._st),
            ("st", 0xfe0f, 0x920e, self._st),
            ("st", 0xfe0f, 0x8208, self._st),
            ("st", 0xfe0f, 0x9209, self._st),
            ("st", 0xfe0f, 0x920a, self._st),
            ("st", 0xfe0f, 0x8200, self._st),
            ("st", 0xfe0f, 0x9201, self._st),
            ("st", 0xfe0f, 0x9202, self._st),
            ("std", 0xd208, 0x8208, self._std),
            ("std", 0xd208, 0x8200, self._std),
            ("lpm", 0xffff, 0x95c8, self._lpm),
            ("lpm", 0xfe0f, 0x9004, self._lpm),
            ("lpm", 0xfe0f, 0x9005, self._lpm),
            ("elpm", 0xffff, 0x95d8, self._elpm),
            ("elpm", 0xfe0f, 0x9006, self._elpm),
            ("elpm", 0xfe0f, 0x9007, self._elpm),
            ("spm", 0xffff, 0x95e8, self._spm),
            ("spm", 0xffff, 0x95f8, self._spm),
            ("in", 0xf800, 0xb000, self._in),
            ("out", 0xf800, 0xb800, self._out),
            ("push", 0xfe0f, 0x920f, self._push),
            ("pop", 0xfe0f, 0x900f, self._pop),
            ("xch", 0xfe0f, 0x9204, self._xch),
            ("las", 0xfe0f, 0x9205, self._las),
            ("lac", 0xfe0f, 0x9206, self._lac),
            ("lat", 0xfe0f, 0x9207, self._lat),
            ("jmp", 0xfe0e, 0x940c, self._jmp),
            ("rjmp", 0xf000, 0xc000, self._rjmp),
            ("ijmp", 0xffff, 0x9409, self._ijmp),
            ("eijmp", 0xffff, 0x9419, self._eijmp),
            ("call", 0xfe0e, 0x940e, self._call),
            ("rcall", 0xf000, 0xd000, self._rcall),
            ("icall", 0xffff, 0x9509, self._icall),
            ("eicall", 0xffff, 0x9519, self._eicall),
            ("ret", 0xffff, 0x9508, self._ret),
            ("reti", 0xffff, 0x9518, self._reti),
            ("cpse", 0xfc00, 0x1000, self._cpse),
            ("cp", 0xfc00, 0x1400, self._cp),
            ("cpc", 0xfc00, 0x0400, self._cpc),
            ("cpi", 0xf000, 0x3000, self._cpi),
            ("sbrc", 0xfe08, 0xfc00, self._sbrc),
            ("sbrs", 0xfe08, 0xfe00, self._sbrs),
            ("sbic", 0xff00, 0x9900, self._sbic),
            ("sbis", 0xff00, 0x9b00, self._sbis),
            ("brbs", 0xfc00, 0xf000, self._brbs),
            ("brbc", 0xfc00, 0xf400, self._brbc),
            ("lsr", 0xfe0f, 0x9406, self._lsr),
            ("ror", 0xfe0f, 0x9407, self._ror),
            ("asr", 0xfe0f, 0x9405, self._asr),
            ("swap", 0xfe0f, 0x9402, self._swap),
            ("sbi", 0xff00, 0x9a00, self._sbi),
            ("cbi", 0xff00, 0x9800, self._cbi),
            ("bst", 0xfe08, 0xfa00, self._bst),
            ("bld", 0xfe08, 0xf800, self._bld),
            ("bset", 0xff8f, 0x9408, self._bset),
            ("bclr", 0xff8f, 0x9488, self._bclr),
            ("break", 0xffff, 0x9598, self._break),
            ("nop", 0xffff, 0x0000, self._nop),
            ("sleep", 0xffff, 0x9588, self._sleep),
            ("wdr", 0xffff, 0x95a8, self._wdr)
        ].forEach { instruction in self.instructions.append(instruction) }
    }

    public func size(opcode: UInt16) -> Int {
        switch (match(opcode).0) {
        case "jmp": return 2
        case "call": return 2
        default: return 1
        }
    }

    public func decode(opcode: UInt16, core: Core) {
        match(opcode).3(opcode, core)
    }

    // MARK: Arithmetic and Logic

    private func _adc(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let r = Int(((opcode & 0x0200) >> 5) | (opcode & 0x000f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd &+ Rr &+ (core.sreg.c ? 1 : 0)

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _add(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let r = Int(((opcode & 0x0200) >> 5) | (opcode & 0x000f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd &+ Rr

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _adiw(opcode: UInt16, core: Core) {
        let d = Int(((opcode & 0x0030) >> 4) * 2) + 24;
        let K = ((opcode & 0x00c0) >> 2) | (opcode & 0x000f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd &+ K

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sub(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let r = Int(((opcode & 0x0200) >> 5) | (opcode & 0x000f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd &- Rr

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _subi(opcode: UInt16, core: Core) {
        let d = Int(((opcode & 0x00f0) >> 4) + 16)
        let K = ((opcode & 0x0f00) >> 4) | (opcode & 0x000f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd &- K

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sbc(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let r = Int(((opcode & 0x0200) >> 5) | (opcode & 0x000f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd &- Rr &- (core.sreg.c ? 1 : 0)

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sbci(opcode: UInt16, core: Core) {
        let d = Int(((opcode & 0x00f0) >> 4) + 16)
        let K = ((opcode & 0x0f00) >> 4) | (opcode & 0x000f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd &- K &- (core.sreg.c ? 1 : 0)

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sbiw(opcode: UInt16, core: Core) {
        let d = Int(((opcode & 0x0030) >> 4) * 2) + 24;
        let K = ((opcode & 0x00c0) >> 2) | (opcode & 0x000f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd &- K

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _and(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let r = Int(((opcode & 0x0200) >> 5) | (opcode & 0x000f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd & Rr

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _andi(opcode: UInt16, core: Core) {
        let d = Int(((opcode & 0x00f0) >> 4) + 16)
        let K = ((opcode & 0x0f00) >> 4) | (opcode & 0x000f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd & K

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _or(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let r = Int(((opcode & 0x0200) >> 5) | (opcode & 0x000f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd | Rr

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _ori(opcode: UInt16, core: Core) {
        let d = Int(((opcode & 0x00f0) >> 4) + 16)
        let K = ((opcode & 0x0f00) >> 4) | (opcode & 0x000f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd | K

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _eor(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let r = Int(((opcode & 0x0200) >> 5) | (opcode & 0x000f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd ^ Rr

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _com(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)

        let Rd = core.registers[d] as UInt8
        let R  = 0xff &- Rd

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _neg(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)

        let Rd = core.registers[d] as UInt8
        let R  = 0 &- Rd

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _inc(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)

        let Rd = core.registers[d] as UInt8
        let R  = Rd &+ 1

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _dec(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)

        let Rd = core.registers[d] as UInt8
        let R  = Rd &- 1

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _ser(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x00f0) >> 4) + 16

        core.registers[d] = 0xff as UInt8
        core.pc           = core.pc + 1
    }

    private func _mul(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let r = Int(((opcode & 0x0200) >> 5) | (opcode & 0x000f))
        
        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = UInt16(Rd) &* UInt16(Rr)
        
        core.registers[0] = R
        core.pc           = core.pc + 1
    }

    private func _muls(opcode: UInt16, core: Core) {
        let d = Int(((opcode & 0x00f0) >> 4) + 16)
        let r = Int((opcode & 0x000f) + 16)
        
        let Rd = Int8(bitPattern: core.registers[d] as UInt8)
        let Rr = Int8(bitPattern: core.registers[r] as UInt8)
        let R  = Int16(Rd) &* Int16(Rr)
        
        core.registers[0] = UInt16(bitPattern: R)
        core.pc           = core.pc + 1
    }

    private func _mulsu(opcode: UInt16, core: Core) {
        let d = Int(((opcode & 0x00f0) >> 4) + 16)
        let r = Int((opcode & 0x000f) + 16)
        
        let Rd = Int8(bitPattern: core.registers[d] as UInt8)
        let Rr = core.registers[r] as UInt8
        let R  = Int16(Rd) &* Int16(bitPattern: UInt16(Rr))
        
        core.registers[0] = UInt16(bitPattern: R)
        core.pc           = core.pc + 1
    }

    private func _fmul(opcode: UInt16, core: Core) {
    }

    private func _fmuls(opcode: UInt16, core: Core) {
    }

    private func _fmulsu(opcode: UInt16, core: Core) {
    }

    // MARK: Data Transfer

    private func _mov(opcode: UInt16, core: Core) {
    }

    private func _movw(opcode: UInt16, core: Core) {
    }

    private func _ldi(opcode: UInt16, core: Core) {
    }

    private func _lds(opcode: UInt16, core: Core) {
    }

    private func _ld(opcode: UInt16, core: Core) {
    }

    private func _ldd(opcode: UInt16, core: Core) {
    }

    private func _sts(opcode: UInt16, core: Core) {
    }

    private func _st(opcode: UInt16, core: Core) {
    }

    private func _std(opcode: UInt16, core: Core) {
    }

    private func _lpm(opcode: UInt16, core: Core) {
    }

    private func _elpm(opcode: UInt16, core: Core) {
    }

    private func _spm(opcode: UInt16, core: Core) {
    }

    private func _in(opcode: UInt16, core: Core) {
    }

    private func _out(opcode: UInt16, core: Core) {
    }

    private func _push(opcode: UInt16, core: Core) {
    }

    private func _pop(opcode: UInt16, core: Core) {
    }

    private func _xch(opcode: UInt16, core: Core) {
    }

    private func _las(opcode: UInt16, core: Core) {
    }

    private func _lac(opcode: UInt16, core: Core) {
    }

    private func _lat(opcode: UInt16, core: Core) {
    }

    // MARK: Branching

    private func _jmp(opcode: UInt16, core: Core) {
    }

    private func _rjmp(opcode: UInt16, core: Core) {
    }

    private func _ijmp(opcode: UInt16, core: Core) {
    }

    private func _eijmp(opcode: UInt16, core: Core) {
    }

    private func _call(opcode: UInt16, core: Core) {
    }

    private func _rcall(opcode: UInt16, core: Core) {
    }

    private func _icall(opcode: UInt16, core: Core) {
    }

    private func _eicall(opcode: UInt16, core: Core) {
    }

    private func _ret(opcode: UInt16, core: Core) {
    }

    private func _reti(opcode: UInt16, core: Core) {
    }

    private func _cpse(opcode: UInt16, core: Core) {
    }

    private func _cp(opcode: UInt16, core: Core) {
    }

    private func _cpc(opcode: UInt16, core: Core) {
    }

    private func _cpi(opcode: UInt16, core: Core) {
    }

    private func _sbrc(opcode: UInt16, core: Core) {
    }

    private func _sbrs(opcode: UInt16, core: Core) {
    }

    private func _sbic(opcode: UInt16, core: Core) {
    }

    private func _sbis(opcode: UInt16, core: Core) {
    }

    private func _brbs(opcode: UInt16, core: Core) {
    }

    private func _brbc(opcode: UInt16, core: Core) {
    }

    // MARK: Bit and Bit-test

    private func _lsr(opcode: UInt16, core: Core) {
    }

    private func _ror(opcode: UInt16, core: Core) {
    }

    private func _asr(opcode: UInt16, core: Core) {
    }

    private func _swap(opcode: UInt16, core: Core) {
    }

    private func _sbi(opcode: UInt16, core: Core) {
    }

    private func _cbi(opcode: UInt16, core: Core) {
    }

    private func _bst(opcode: UInt16, core: Core) {
    }

    private func _bld(opcode: UInt16, core: Core) {
    }

    private func _bset(opcode: UInt16, core: Core) {
    }

    private func _bclr(opcode: UInt16, core: Core) {
    }

    // MARK: MCU Control

    private func _break(opcode: UInt16, core: Core) {
    }

    private func _sleep(opcode: UInt16, core: Core) {
    }

    private func _wdr(opcode: UInt16, core: Core) {
    }

    private func _nop(_: UInt16, core: Core) {
    }

    // MARK: Instruction matching

    private func match(_ opcode: UInt16) -> Instruction {
        let instruction = self.instructions.first { instruction in
            return opcode & instruction.1 == instruction.2
        }

        return instruction != nil
            ? instruction!
            : ("nop", 0xffff, 0x0000, self._nop) as Instruction
    }
}
