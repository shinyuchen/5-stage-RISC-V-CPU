# inst.txt rules
# R-type = op rd, r1, r2
# I-type = op rd, r1
# S-type = op r2, r1, imm (r2 = mem[r1 + imm])
# B-type = op r1, r2, imm
# U-type = op rd, imm
# J-type = op rd, imm
OPCODE = {
    'lui'       : '0110111',
    'auipc'     : '0010111',
    'jal'       : '1101111',
    'jalr'      : '1100111',
    'beq'       : '1100011',
    'bne'       : '1100011',
    'blt'       : '1100011',
    'bge'       : '1100011',
    'bltu'      : '1100011',
    'bgeu'      : '1100011',
    'lb'        : '0000011',
    'lh'        : '0000011',
    'lw'        : '0000011',
    'lbu'       : '0000011',
    'lhu'       : '0000011',
    'sb'        : '0100011',
    'sh'        : '0100011',
    'sw'        : '0100011',
    'addi'      : '0010011',
    'slti'      : '0010011',
    'sltiu'     : '0010011',
    'xori'      : '0010011',
    'ori'       : '0010011',
    'andi'      : '0010011',
    'slli'      : '0010011',
    'srli'      : '0010011',
    'srai'      : '0010011',
    'add'       : '0110011',
    'sub'       : '0110011',
    'sll'       : '0110011',
    'slt'       : '0110011',
    'sltu'      : '0110011',
    'xor'       : '0110011',
    'srl'       : '0110011',
    'sra'       : '0110011',
    'or'        : '0110011',
    'and'       : '0110011'
}

FUNCT7 = {
    'add'       : '0000000',
    'sub'       : '0100000',
    'sll'       : '0000000',
    'slt'       : '0000000',
    'sltu'      : '0000000',
    'xor'       : '0000000',
    'srl'       : '0000000',
    'sra'       : '0100000',
    'or'       :  '0000000',
    'and'       : '0000000'
}

FUNCT3 = {
    'jalr'      : '000',
    'beq'       : '000',
    'bne'       : '001',
    'blt'       : '100',
    'bge'       : '101',
    'bltu'      : '110',
    'bgeu'      : '111',
    'lb'        : '000',
    'lh'        : '001',
    'lw'        : '010',
    'lbu'       : '100',
    'lhu'       : '101',
    'sb'        : '000',
    'sh'        : '001',
    'sw'        : '010',
    'addi'      : '000',
    'slti'      : '010',
    'sltiu'     : '011',
    'xori'      : '100',
    'ori'       : '110',
    'andi'      : '111',
    'slli'      : '001',
    'srli'      : '101',
    'srai'      : '101',
    'add'       : '000',
    'sub'       : '000',
    'sll'       : '001',
    'slt'       : '010',
    'sltu'      : '011',
    'xor'       : '100',
    'srl'       : '101',
    'sra'       : '101',
    'or'        : '110',
    'and'       : '111'
}

TYPE = {
    'lui'       : 'U',
    'auipc'     : 'U',
    'jal'       : 'J',
    'jalr'      : 'I',
    'beq'       : 'B',
    'bne'       : 'B',
    'blt'       : 'B',
    'bge'       : 'B',
    'bltu'      : 'B',
    'bgeu'      : 'B',
    'lb'        : 'I',
    'lh'        : 'I',
    'lw'        : 'I',
    'lbu'       : 'I',
    'lhu'       : 'I',
    'sb'        : 'S',
    'sh'        : 'S',
    'sw'        : 'S',
    'addi'      : 'I',
    'slti'      : 'I',
    'sltiu'     : 'I',
    'xori'      : 'I',
    'ori'       : 'I',
    'andi'      : 'I',
    'slli'      : 'I',
    'srli'      : 'I',
    'srai'      : 'I',
    'add'       : 'R',
    'sub'       : 'R',
    'sll'       : 'R',
    'slt'       : 'R',
    'sltu'      : 'R',
    'xor'       : 'R',
    'srl'       : 'R',
    'sra'       : 'R',
    'or'        : 'R',
    'and'       : 'R'
}

def bindigits(n, bits):
    s = bin(n & int("1"*bits, 2))[2:]
    return ("{0:0>%s}" % (bits)).format(s)

def convert_imm(bits, n):
    if(int(bits) < 0):
        imm_bin = bindigits(int(bits), n)
    else:
        imm = int(bits)
        imm_bin = '{0:0{1}b}'.format(imm, n)
    return imm_bin

def register_src(reg):
    reg_int = int(reg.replace('r',''))
    reg_bin = '{0:05b}'.format(reg_int)
    return reg_bin

def convert_to_binary(inst):
    inst_list = inst.replace('\n', '').replace(',', '').split(" ")
    if(TYPE[inst_list[0]] == 'R'):
        print(inst_list)
        funct7 = FUNCT7[inst_list[0]]
        funct3 = FUNCT3[inst_list[0]]
        opcode = OPCODE[inst_list[0]]
        rd_bin = register_src(inst_list[1])
        rs1_bin = register_src(inst_list[2])
        rs2_bin = register_src(inst_list[3])
        inst_binary = funct7 + rs2_bin + rs1_bin + funct3 + rd_bin + opcode
        return inst_binary
    elif(TYPE[inst_list[0]] == 'I'):
        funct3 = FUNCT3[inst_list[0]]
        opcode = OPCODE[inst_list[0]]
        imm_bin = convert_imm(inst_list[3], 12)
        if((funct3 == '101') & (inst_list[0] == 'srai')):
            imm_bin = '01' + imm_bin[2:]
        rd_bin = register_src(inst_list[1])
        rs1_bin = register_src(inst_list[2])
        inst_binary = imm_bin + rs1_bin + funct3 + rd_bin + opcode
        return inst_binary
    elif(TYPE[inst_list[0]] == 'B'):
        funct3 = FUNCT3[inst_list[0]]
        opcode = OPCODE[inst_list[0]]
        imm_bin = convert_imm(inst_list[3], 13)
        imm_head_bin = imm_bin[0] + imm_bin[2:8]
        imm_tail_bin = imm_bin[8:12] + imm_bin[1:2]
        rs1_bin = register_src(inst_list[1])
        rs2_bin = register_src(inst_list[2])
        inst_binary = imm_head_bin + rs2_bin + rs1_bin + funct3 + imm_tail_bin + opcode
        return inst_binary
    elif(TYPE[inst_list[0]] == 'S'):
        funct3 = FUNCT3[inst_list[0]]
        opcode = OPCODE[inst_list[0]]
        imm_bin = convert_imm(inst_list[3], 12)
        imm_upper_bin = imm_bin[0:7]
        imm_lower_bin = imm_bin[7:12]
        rs2_bin = register_src(inst_list[1])
        rs1_bin = register_src(inst_list[2])
        inst_binary = imm_upper_bin + rs2_bin + rs1_bin + funct3 + imm_lower_bin + opcode
        return inst_binary
    elif(TYPE[inst_list[0]] == 'U'):
        print(inst_list)
        opcode = OPCODE[inst_list[0]]
        rd_bin = register_src(inst_list[1])
        imm_bin = convert_imm(inst_list[2], 32)
        imm_bin = imm_bin[0:20]
        inst_binary = imm_bin + rd_bin + opcode
        return inst_binary
    elif(TYPE[inst_list[0]] == 'J'):
        opcode = OPCODE[inst_list[0]]
        rd_bin = register_src(inst_list[1])
        imm_bin = convert_imm(inst_list[2], 21)
        imm_bin_reordered = imm_bin[0] + imm_bin[10:20] + imm_bin[9] + imm_bin[1:9]
        inst_binary = imm_bin_reordered + rd_bin + opcode
        return inst_binary

def main():
    print("start")

    with open('testing/inst.txt') as f:
        lines = f.readlines()
        f.close()
    bin_str_pair = {}
    with open('testing/inst_bin.txt', 'w') as f:
        for inst in lines:
            inst_binary = convert_to_binary(inst)
            f.write(inst_binary + '\n')
            print(inst + ' : ' +inst_binary)
            bin_str_pair[inst_binary] = inst
        f.write("11111111111111111111111111111111\n")
        f.close()

main()