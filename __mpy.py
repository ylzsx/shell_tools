import struct

def bin_with_commas(n):
    b = bin(n)[2:]
    b = b.zfill(((len(b) + 3) // 4) * 4)
    binary_with_commas = "'".join([b[i:i+4] for i in range(0, len(b), 4)])
    return "0b'" + binary_with_commas

def complement_decode(hex_str: str, bits: int = 64) -> int:
    val = int(hex_str, 16)
    if val >= 2**(bits - 1):
        val -= 2**bits
    return val

def complement_code(value: int, bits: int = 64) -> str:
    mask = (1 << bits) - 1
    return hex(value & mask)

def float_to_hex(f):
    packed = struct.pack('!f', f)
    return '0x' + ''.join(f'{byte:02x}' for byte in packed)

def double_to_hex(d):
    packed = struct.pack('!d', d)
    return '0x' + ''.join(f'{byte:02x}' for byte in packed)

def float_to_bin(f):
    packed = struct.pack('!f', f)
    return '0b' + ''.join(f'{byte:08b}' for byte in packed)

def double_to_bin(d):
    packed = struct.pack('!d', d)
    return '0b' + ''.join(f'{byte:08b}' for byte in packed)

def ieee754_to_float(value):
    hex_str = hex(value)[2:]
    if len(hex_str) < 8:
        hex_str = hex_str.zfill(8)
    hex_value = bytes.fromhex(hex_str)
    unpacked_float = struct.unpack('!f', hex_value)[0]
    return unpacked_float

def ieee754_to_double(value):
    hex_str = hex(value)[2:]
    if len(hex_str) < 16:
        hex_str = hex_str.zfill(16)
    hex_value = bytes.fromhex(hex_str)
    unpacked_double = struct.unpack('!d', hex_value)[0]
    return unpacked_double
