import Foundation

class Decoder {
    typealias Handler = (_: UInt16, _: Core) -> Void
    typealias Instruction = (String, UInt16, UInt16, Handler)

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

    // MARK: - Arithmetic and Logic

    private func _adc(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd &+ Rr &+ (core.sreg.c ? 1 : 0)

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _add(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd &+ Rr

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _adiw(opcode: UInt16, core: Core) {
        let d = (Int(opcode & 0x0030) * 2) + 24
        let K = opcode.mask(0x00cf)

        let Rd = core.registers[d] as UInt16
        let R  = Rd &+ K

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sub(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd &- Rr

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _subi(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) + 16
        let K = opcode.mask(0x0f0f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd &- K

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sbc(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd &- Rr &- (core.sreg.c ? 1 : 0)

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sbci(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) + 16
        let K = opcode.mask(0x0f0f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd &- K &- (core.sreg.c ? 1 : 0)

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sbiw(opcode: UInt16, core: Core) {
        let d = (Int(opcode & 0x0030) * 2) + 24
        let K = opcode.mask(0x00cf)

        let Rd = core.registers[d] as UInt16
        let R  = Rd &- K

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _and(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd & Rr

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _andi(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) + 16
        let K = opcode.mask(0x0f0f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd & K

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _or(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd | Rr

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _ori(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) + 16
        let K = opcode.mask(0x0f0f)

        let Rd = core.registers[d] as UInt16
        let R  = Rd | K

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _eor(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = Rd ^ Rr

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _com(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))

        let Rd = core.registers[d] as UInt8
        let R  = 0xff &- Rd

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _neg(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))

        let Rd = core.registers[d] as UInt8
        let R  = 0 &- Rd

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _inc(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))

        let Rd = core.registers[d] as UInt8
        let R  = Rd &+ 1

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _dec(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))

        let Rd = core.registers[d] as UInt8
        let R  = Rd &- 1

        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _ser(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) + 16

        core.registers[d] = 0xff as UInt8
        core.pc           = core.pc + 1
    }

    private func _mul(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let R  = UInt16(Rd) &* UInt16(Rr)

        // TODO: Update status register

        core.registers[0] = R
        core.pc           = core.pc + 1
    }

    private func _muls(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) + 16
        let r = Int(opcode.mask(0x000f)) + 16

        let Rd = Int8(bitPattern: core.registers[d] as UInt8)
        let Rr = Int8(bitPattern: core.registers[r] as UInt8)
        let R  = Int16(Rd) &* Int16(Rr)

        // TODO: Update status register

        core.registers[0] = UInt16(bitPattern: R)
        core.pc           = core.pc + 1
    }

    private func _mulsu(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) + 16
        let r = Int(opcode.mask(0x000f)) + 16

        let Rd = Int8(bitPattern: core.registers[d] as UInt8)
        let Rr = core.registers[r] as UInt8
        let R  = Int16(Rd) &* Int16(bitPattern: UInt16(Rr))

        // TODO: Update status register

        core.registers[0] = UInt16(bitPattern: R)
        core.pc           = core.pc + 1
    }

    private func _fmul(opcode: UInt16, core: Core) {
        // TODO: Implement instruction
    }

    private func _fmuls(opcode: UInt16, core: Core) {
        // TODO: Implement instruction
    }

    private func _fmulsu(opcode: UInt16, core: Core) {
        // TODO: Implement instruction
    }

    // MARK: - Data Transfer

    private func _mov(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))

        core.registers[d] = core.registers[r] as UInt8
        core.pc           = core.pc + 1
    }

    private func _movw(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) * 2
        let r = Int(opcode.mask(0x000f)) * 2

        core.registers[d] = core.registers[r] as UInt16
        core.pc           = core.pc + 1
    }

    private func _ldi(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x00f0)) + 16
        let K = UInt8(opcode.mask(0x0f0f))

        core.registers[d] = K
        core.pc           = core.pc + 1
    }

    private func _lds(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let k = Int(core.program[Int(core.pc + 1)])

        core.registers[d] = core.data[k] as UInt8
        core.pc           = core.pc + 2
    }

    private func _ld(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)

        if ((opcode & 0xfe0f) == 0x900c) {
            core.registers[d] = core.data[Int(core.x)] as UInt8
        } else if ((opcode & 0xfe0f) == 0x900d) {
            core.registers[d] = core.data[Int(core.x)] as UInt8
            core.x            = core.x + 1
        } else if ((opcode & 0xfe0f) == 0x900e) {
            core.x            = core.x - 1
            core.registers[d] = core.data[Int(core.x)] as UInt8
        } else if ((opcode & 0xfe0f) == 0x8008) {
            core.registers[d] = core.data[Int(core.y)] as UInt8
        } else if ((opcode & 0xfe0f) == 0x9009) {
            core.registers[d] = core.data[Int(core.y)] as UInt8
            core.y            = core.y + 1
        } else if ((opcode & 0xfe0f) == 0x900a) {
            core.y            = core.y - 1
            core.registers[d] = core.data[Int(core.y)] as UInt8
        } else if ((opcode & 0xfe0f) == 0x8000) {
            core.registers[d] = core.data[Int(core.z)] as UInt8
        } else if ((opcode & 0xfe0f) == 0x9001) {
            core.registers[d] = core.data[Int(core.z)] as UInt8
            core.z            = core.z + 1
        } else if ((opcode & 0xfe0f) == 0x9002) {
            core.z            = core.z - 1
            core.registers[d] = core.data[Int(core.z)] as UInt8
        }

        core.pc = core.pc + 1
    }

    private func _ldd(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let q = opcode.mask(0x2c07)

        if ((opcode & 0xd208) == 0x8008 && opcode != 0x8008) {
            core.registers[d] = core.data[Int(core.y &+ q)] as UInt8
        } else if ((opcode & 0xd208) == 0x8000 && opcode != 0x8000) {
            core.registers[d] = core.data[Int(core.y &+ q)] as UInt8
        }

        core.pc = core.pc + 1
    }

    private func _sts(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)
        let k = Int(core.program[Int(core.pc + 1)] as UInt16)

        core.data[k] = core.registers[d] as UInt8
        core.pc      = core.pc + 2
    }

    private func _st(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)

        if ((opcode & 0xfe0f) == 0x920c) {
            core.data[Int(core.x)] = core.registers[d] as UInt8
        } else if ((opcode & 0xfe0f) == 0x920d) {
            core.data[Int(core.x)] = core.registers[d] as UInt8
            core.x                 = core.x + 1
        } else if ((opcode & 0xfe0f) == 0x920e) {
            core.x                 = core.x - 1
            core.data[Int(core.x)] = core.registers[d] as UInt8
        } else if ((opcode & 0xfe0f) == 0x8208) {
            core.data[Int(core.y)] = core.registers[d] as UInt8
        } else if ((opcode & 0xfe0f) == 0x9209) {
            core.data[Int(core.y)] = core.registers[d] as UInt8
            core.y                 = core.y + 1
        } else if ((opcode & 0xfe0f) == 0x920a) {
            core.y                 = core.y - 1
            core.data[Int(core.y)] = core.registers[d] as UInt8
        } else if ((opcode & 0xfe0f) == 0x8200) {
            core.data[Int(core.z)] = core.registers[d] as UInt8
        } else if ((opcode & 0xfe0f) == 0x9201) {
            core.data[Int(core.z)] = core.registers[d] as UInt8
            core.z                 = core.z + 1
        } else if ((opcode & 0xfe0f) == 0x9202) {
            core.z                 = core.z - 1
            core.data[Int(core.z)] = core.registers[d] as UInt8
        }

        core.pc = core.pc + 1
    }

    private func _std(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let q = opcode.mask(0x2c07)

        if ((opcode & 0xd208) == 0x8208 && opcode != 0x8208) {
            core.data[Int(core.y &+ q)] = core.registers[d] as UInt8
        } else if ((opcode & 0xd208) == 0x8200 && opcode != 0x8200) {
            core.data[Int(core.z &+ q)] = core.registers[d] as UInt8
        }

        core.pc = core.pc + 1
    }

    private func _lpm(opcode: UInt16, core: Core) {
        // TODO: Implement instruction
        core.pc = core.pc + 1
    }

    private func _elpm(opcode: UInt16, core: Core) {
        // TODO: Implement instruction
        core.pc = core.pc + 1
    }

    private func _spm(opcode: UInt16, core: Core) {
        // TODO: Implement instruction
        core.pc = core.pc + 1
    }

    private func _in(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let A = Int(opcode.mask(0x060f))

        core.registers[d] = core.io[A] as UInt8
        core.pc           = core.pc + 1
    }

    private func _out(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let A = Int(opcode.mask(0x060f))

        core.io[A] = core.registers[d] as UInt8
        core.pc    = core.pc + 1
    }

    private func _push(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)

        core.data[Int(core.sp)] = core.registers[d] as UInt8
        core.sp                 = core.sp - 1
        core.pc                 = core.pc + 1
    }

    private func _pop(opcode: UInt16, core: Core) {
        let d = Int((opcode & 0x01f0) >> 4)

        core.sp           = core.sp + 1
        core.registers[d] = core.data[Int(core.sp)] as UInt8
        core.pc           = core.pc + 1
    }

    private func _xch(opcode: UInt16, core: Core) {
        let r = Int((opcode & 0x01f0) >> 4)

        let Rr = core.registers[r] as UInt8
        let Rz = core.data[Int(core.z)] as UInt8

        core.registers[r]      = Rz
        core.data[Int(core.z)] = Rr
        core.pc                = core.pc + 1
    }

    private func _las(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    private func _lac(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    private func _lat(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    // MARK: Branching

    private func _jmp(opcode: UInt16, core: Core) {
        let kh = ((opcode & 0x01f0) >> 3) | (opcode & 0x1)
        let kl = core.program[Int(core.pc + 1)]
        let k  = UInt32(kh) << 16 | UInt32(kl)

        core.pc = k
    }

    private func _rjmp(opcode: UInt16, core: Core) {
        let k  = UInt32(opcode & 0x0fff) << 20
        let Rk = Int32(bitPattern: k) < 0 ? ((k >> 20) | (0xfffff000)) : (k >> 20)
        let R  = Int32(bitPattern: core.pc) &+ 1 &+ Int32(bitPattern: Rk)

        core.pc = UInt32(bitPattern: R)
    }

    private func _ijmp(opcode: UInt16, core: Core) {
        core.pc = UInt32(core.z)
    }

    private func _eijmp(opcode: UInt16, core: Core) {
    }

    private func _call(opcode: UInt16, core: Core) {
        let kh = UInt32(opcode.mask(0x01f1))
        let kl = UInt32(core.program[Int(core.pc + 1)])
        let k  = kh << 16 | kl

        if (core.pcSize == .Bit16) {
            core.data[Int(core.sp)]     = UInt8((core.pc + 2).mask(0xff00))
            core.data[Int(core.sp - 1)] = UInt8((core.pc + 2).mask(0x00ff))
            core.sp                     = core.sp &- 2
        } else if (core.pcSize == .Bit22) {
            core.data[Int(core.sp)]     = UInt8((core.pc + 2).mask(0xff0000))
            core.data[Int(core.sp - 1)] = UInt8((core.pc + 2).mask(0x00ff00))
            core.data[Int(core.sp - 2)] = UInt8((core.pc + 2).mask(0x0000ff))
            core.sp                     = core.sp &- 3
        }

        core.pc = k
    }

    private func _rcall(opcode: UInt16, core: Core) {
        let k  = UInt32(opcode & 0x0fff) << 20
        let Rk = Int32(bitPattern: k) < 0 ? ((k >> 20) | (0xfffff000)) : (k >> 20)
        let R  = Int32(bitPattern: core.pc) &+ 1 &+ Int32(bitPattern: Rk)

        if (core.pcSize == .Bit16) {
            core.data[Int(core.sp)]     = UInt8((core.pc + 1).mask(0xff00))
            core.data[Int(core.sp - 1)] = UInt8((core.pc + 1).mask(0x00ff))
            core.sp                     = core.sp &- 2
        } else if (core.pcSize == .Bit22) {
            core.data[Int(core.sp)]     = UInt8((core.pc + 1).mask(0xff0000))
            core.data[Int(core.sp - 1)] = UInt8((core.pc + 1).mask(0x00ff00))
            core.data[Int(core.sp - 2)] = UInt8((core.pc + 1).mask(0x0000ff))
            core.sp                     = core.sp &- 3
        }

        core.pc = UInt32(bitPattern: R)
    }

    private func _icall(opcode: UInt16, core: Core) {
        if (core.pcSize == .Bit16) {
            core.data[Int(core.sp)]     = UInt8((core.pc + 1).mask(0xff00))
            core.data[Int(core.sp - 1)] = UInt8((core.pc + 1).mask(0x00ff))
            core.sp                     = core.sp &- 2
        } else if (core.pcSize == .Bit22) {
            core.data[Int(core.sp)]     = UInt8((core.pc + 1).mask(0xff0000))
            core.data[Int(core.sp - 1)] = UInt8((core.pc + 1).mask(0x00ff00))
            core.data[Int(core.sp - 2)] = UInt8((core.pc + 1).mask(0x0000ff))
            core.sp                     = core.sp &- 3
        }

        core.pc = UInt32(core.z)
    }

    private func _eicall(opcode: UInt16, core: Core) {
    }

    private func _ret(opcode: UInt16, core: Core) {
        if (core.pcSize == .Bit16) {
            let k = UInt32.fromBytes([
                core.data[Int(core.sp + 2)] as UInt8,
                core.data[Int(core.sp + 1)] as UInt8
            ])

            core.pc = k
            core.sp = core.sp + 2
        } else if (core.pcSize == .Bit22) {
            let k = UInt32.fromBytes([
                core.data[Int(core.sp + 3)] as UInt8,
                core.data[Int(core.sp + 2)] as UInt8,
                core.data[Int(core.sp + 1)] as UInt8
            ])

            core.pc = k
            core.sp = core.sp + 3
        }
    }

    private func _reti(opcode: UInt16, core: Core) {
        if (core.pcSize == .Bit16) {
            let k = UInt32.fromBytes([
                core.data[Int(core.sp + 2)] as UInt8,
                core.data[Int(core.sp + 1)] as UInt8
                ])

            core.pc = k
            core.sp = core.sp + 2
        } else if (core.pcSize == .Bit22) {
            let k = UInt32.fromBytes([
                core.data[Int(core.sp + 3)] as UInt8,
                core.data[Int(core.sp + 2)] as UInt8,
                core.data[Int(core.sp + 1)] as UInt8
                ])

            core.pc = k
            core.sp = core.sp + 3
        }

        core.sreg.i = true
    }

    private func _cpse(opcode: UInt16, core: Core) {
        let d = Int(opcode.mask(0x01f0))
        let r = Int(opcode.mask(0x020f))
        
        let Rd = core.registers[d] as UInt8
        let Rr = core.registers[r] as UInt8
        let k  = UInt32(size(opcode: core.program[Int(core.pc + 1)]))
        
        core.pc = core.pc + 1 + (Rd == Rr ? k : 0)
    }

    private func _cp(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    private func _cpc(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    private func _cpi(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    private func _sbrc(opcode: UInt16, core: Core) {
        let b = Int(opcode.mask(0x0007))
        let r = Int(opcode.mask(0x01f0))
        
        let Rr = core.registers[r] as UInt8
        let k  = UInt32(size(opcode: core.program[Int(core.pc + 1)]))

        core.pc = core.pc + 1 + (Rr[b] ? 0 : k)
    }

    private func _sbrs(opcode: UInt16, core: Core) {
        let b = Int(opcode.mask(0x0007))
        let r = Int(opcode.mask(0x01f0))
        
        let Rr = core.registers[r] as UInt8
        let k  = UInt32(size(opcode: core.program[Int(core.pc + 1)]))
        
        core.pc = core.pc + 1 + (Rr[b] ? k : 0)
    }

    private func _sbic(opcode: UInt16, core: Core) {
        let b = Int(opcode.mask(0x0007))
        let A = Int(opcode.mask(0x00f8))
        
        let RA = core.io[A] as UInt8
        let k  = UInt32(size(opcode: core.program[Int(core.pc + 1)]))

        core.pc = core.pc + 1 + (RA[b] ? 0 : k)
    }

    private func _sbis(opcode: UInt16, core: Core) {
        let b = Int(opcode.mask(0x0007))
        let A = Int(opcode.mask(0x00f8))
        
        let RA = core.io[A] as UInt8
        let k  = UInt32(size(opcode: core.program[Int(core.pc + 1)]))
        
        core.pc = core.pc + 1 + (RA[b] ? k : 0)
    }

    private func _brbs(opcode: UInt16, core: Core) {
        let s = Int(opcode.mask(0x0007))
        let k = Int8(bitPattern: UInt8(opcode.mask(0x3f8) << 1))
        
        var Rk = k >> 1
        Rk[7]  = k < 0
        
        let Rpc = Int(core.pc) + 1 + (core.sreg[s] ? Int(Rk) : 0)
        core.pc = UInt32(Rpc)
    }

    private func _brbc(opcode: UInt16, core: Core) {
        let s = Int(opcode.mask(0x0007))
        let k = Int8(bitPattern: UInt8(opcode.mask(0x3f8) << 1))
        
        var Rk = k >> 1
        Rk[7]  = k < 0
        
        let Rpc = Int(core.pc) + 1 + (core.sreg[s] ? 0 : Int(Rk))
        core.pc = UInt32(Rpc)
    }

    // MARK: Bit and Bit-test

    private func _lsr(opcode: UInt16, core: Core) {
        let d  = Int(opcode.mask(0x01f0))
        let Rd = core.registers[d] as UInt8
        let R  = Rd >> 1
        
        // TODO: Update status register
        
        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _ror(opcode: UInt16, core: Core) {
        let d  = Int(opcode.mask(0x01f0))
        let Rd = core.registers[d] as UInt8
        let R  = Rd >> 1 | (core.sreg.c ? 0x80 : 0x00)
        
        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _asr(opcode: UInt16, core: Core) {
        let d  = Int(opcode.mask(0x01f0))
        let Rd = core.registers[d] as UInt8
        let R  = Rd >> 1 | (Rd[7] ? 0x80 : 0x00)
        
        // TODO: Update status register

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _swap(opcode: UInt16, core: Core) {
        let d  = Int(opcode.mask(0x01f0))
        let Rd = core.registers[d] as UInt8
        let R  = ((Rd & 0x0f) << 4) | ((Rd & 0xf0) >> 4)

        core.registers[d] = R
        core.pc           = core.pc + 1
    }

    private func _sbi(opcode: UInt16, core: Core) {
        let b  = Int(opcode.mask(0x0007))
        let A  = Int(opcode.mask(0x00f8))
        var RA = core.io[A] as UInt8
        
        RA[b]      = true
        core.io[A] = RA
        core.pc    = core.pc + 1
    }

    private func _cbi(opcode: UInt16, core: Core) {
        let b  = Int(opcode.mask(0x0007))
        let A  = Int(opcode.mask(0x00f8))
        var RA = core.io[A] as UInt8
        
        RA[b]      = false
        core.io[A] = RA
        core.pc    = core.pc + 1
    }

    private func _bst(opcode: UInt16, core: Core) {
        let b  = Int(opcode.mask(0x0007))
        let d  = Int(opcode.mask(0x01f0))
        let Rd = core.registers[d] as UInt8

        core.sreg.t = Rd[b]
        core.pc     = core.pc + 1
    }

    private func _bld(opcode: UInt16, core: Core) {
        let b  = Int(opcode.mask(0x0007))
        let d  = Int(opcode.mask(0x01f0))
        var Rd = core.registers[d] as UInt8
        Rd[b]  = core.sreg.t
        
        core.registers[d] = Rd
        core.pc           = core.pc + 1
        core.pc = core.pc + 1
    }

    private func _bset(opcode: UInt16, core: Core) {
        let s = Int(opcode.mask(0x0070))
        
        core.sreg[s] = true
        core.pc      = core.pc + 1
    }

    private func _bclr(opcode: UInt16, core: Core) {
        let s = Int(opcode.mask(0x0070))

        core.sreg[s] = false
        core.pc      = core.pc + 1
    }

    // MARK: MCU Control

    private func _break(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    private func _sleep(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    private func _wdr(opcode: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    private func _nop(_: UInt16, core: Core) {
        // TODO: Implement instruction

        core.pc = core.pc + 1
    }

    // MARK: Instruction matching

    private func match(_ opcode: UInt16) -> Instruction {
        let instructions: [Instruction] = [
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
        ]

        let instruction = instructions.first { instruction in
            return opcode & instruction.1 == instruction.2
        }

        return instruction != nil
            ? instruction!
            : ("nop", 0xffff, 0x0000, self._nop) as Instruction
    }
}
