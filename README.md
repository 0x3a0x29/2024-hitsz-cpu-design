# 2024-hitsz-cpu-design

---

哈尔滨工业大学（深圳）计算机科学与技术学院2024夏计算机设计与实践实验（包含实验课件和源代码），供学弟学妹们参考学习使用，源代码仅供参考

学校的实验中可以使用RISC-V或者LoongArch作为ISA，此处CPU的ISA为RISC-V

实现的指令总共有37个（在基础要求的24条指令的基础上多实现了13条指令）：
add,sub,and,or,xor,sll,srl,sra,slt,sltu,addi,andi,ori,xori,slli,srli,srai
,slti,sltiu,lb,lbu,lh,lhu,lw,jalr,sb,sh,sw,beq,bne,blt,bltu,bge,bgeu,lui,auipc,jal

单周期CPU频率为40MHz
流水线CPU频率为90MHz

利用前递和停顿的方法解决了数据冒险，利用流水线暂停的方法解决了控制冒险

为了减少重复劳动，使用Python语言编写了能够将汇编语言翻译成机器码或者翻译成本实验使用的coe文件的程序

如果这些内容对你有帮助，可以给我一颗⭐
