'''仅仅支持RISCV中37个指令(支持二进制码、十六进制码和实验所用的coe文件),
不支持伪指令的使用,在程序编写错误的时候会返回报错类型(提示需要修改的问题)但不提供报错位置'''
import sys
#INST的实际意义示意如下:
#num_reg,num_imm,if_label,if_bracket,if_jal
#0:opcode+funct3+funct7,1:opcode+funct3,2:opcode
#opcode,funct3,funct7
INST_R={'add':[(3,0,0,0,0),0,['0110011','000','0000000']],'sub':[(3,0,0,0,0),0,['0110011','000','0100000']],\
    'and':[(3,0,0,0,0),0,['0110011','111','0000000']],'or':[(3,0,0,0,0),0,['0110011','110','0000000']],\
    'xor':[(3,0,0,0,0),0,['0110011','100','0000000']],'sll':[(3,0,0,0,0),0,['0110011','001','0000000']],\
    'srl':[(3,0,0,0,0),0,['0110011','101','0000000']],'sra':[(3,0,0,0,0),0,['0110011','101','0100000']],\
    'slt':[(3,0,0,0,0),0,['0110011','010','0000000']],'sltu':[(3,0,0,0,0),0,['0110011','011','0000000']]}
INST_I={'addi':[(2,1,0,0,0),1,['0010011','000']],'andi':[(2,1,0,0,0),1,['0010011','111']],\
    'ori':[(2,1,0,0,0),1,['0010011','110']],'xori':[(2,1,0,0,0),1,['0010011','100']],\
    'slli':[(2,1,0,0,0),0,['0010011','001','0000000']],'srli':[(2,1,0,0,0),0,['0010011','101','0000000']],\
    'srai':[(2,1,0,0,0),0,['0010011','101','0100000']],'slti':[(2,1,0,0,0),1,['0010011','010']],\
    'sltiu':[(2,1,0,0,0),1,['0010011','011']],'lb':[(2,1,0,1,0),1,['0000011','000']],\
    'lbu':[(2,1,0,1,0),1,['0000011','100']],'lh':[(2,1,0,1,0),1,['0000011','001']],\
    'lhu':[(2,1,0,1,0),1,['0000011','101']],'lw':[(2,1,0,1,0),1,['0000011','010']],\
    'jalr':[(2,1,0,1,0),1,['1100111','000']]}
INST_S={'sb':[(2,1,0,1,0),1,['0100011','000']],'sh':[(2,1,0,1,0),1,['0100011','001']],\
    'sw':[(2,1,0,1,0),1,['0100011','010']]}
INST_B={'beq':[(2,0,1,0,0),1,['1100011','000']],'bne':[(2,0,1,0,0),1,['1100011','001']],\
    'blt':[(2,0,1,0,0),1,['1100011','100']],'bltu':[(2,0,1,0,0),1,['1100011','110']],\
    'bge':[(2,0,1,0,0),1,['1100011','101']],'bgeu':[(2,0,1,0,0),1,['1100011','111']]}
INST_U={'lui':[(1,1,0,0,0),2,['0110111']],'auipc':[(1,1,0,0,0),2,['0010111']]}
INST_J={'jal':[(1,0,1,0,1),2,['1101111']]}
INST={}
INST.update(INST_R)
INST.update(INST_I)
INST.update(INST_S)
INST.update(INST_B)
INST.update(INST_U)
INST.update(INST_J)

class GrammarError(Exception):
    '''一个用于提示语法异常的Exception类,无法提供报错位置,只用于提示报错类型'''
    def __init__(self, msg):
         self.msg = msg
    
    def __str__(self):
         return self.msg
def identifier(s:str)->bool:
    '''判断一个标签是否合法'''
    s=s.replace('$','a')
    if s.isidentifier():
        return True
    return False
def registerNameReplace(s:str='x0')->int:
    '''将一个寄存器名字转换成对应的数字'''
    R=['zero','ra','sp','gp','tp','t0','t1','t2','s0','s1','a0','a1','a2','a3','a4','a5',\
        'a6','a7','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','t3','t4','t5','t6']
    for i in range(32):
        if s==R[i] or s=='x'+str(i):
            s=i
            break
    return s
def isRegisterName(s:str)->bool:
    '''判断一个寄存器是否合法'''
    R=['zero','ra','sp','gp','tp','t0','t1','t2','s0','s1','a0','a1','a2','a3','a4','a5',\
        'a6','a7','s2','s3','s4','s5','s6','s7','s8','s9','s10','s11','t3','t4','t5','t6']
    if s in R:
        return True
    for i in range(32):
        if s=='x'+str(i):
            return True
    return False
def isNumber(s:str)->int:
    '''判断一个数字字符串是否为合法字符串并且返回它所属于的字符串类型'''
    L0=['0','1','2','3','4','5','6','7']
    L1=['0','1','2','3','4','5','6','7','8','9']
    L2=['a','b','c','d','e','f']
    L3=['A','B','C','D','E','F']
    if len(s)==0:
        return -1
    if s[0]=='-':
        if len(s)==1:
            return -1
        s=s[1:]
    if len(s)>2:
        if s[0:2]=='0x' or s[0:2]=='0X':
            s=s[2:]
            flag=0
            for i in s:
                if i not in L1:
                    if i in L2:
                        if flag==2:
                            return -1
                        flag=1
                    elif i in L3:
                        if flag==1:
                            return -1
                        flag=2
                    else:
                        return -1
            if flag==2:
                return 3
            return 2
    if len(s)>1:
        if s[0]=='0':
            s=s[1:]
            for i in s:
                if i not in L0:
                    return -1
            return 0
    for i in s:
        if i not in L1:
            return -1
    return 1
def getNumber(s:str,type:int)->int:
    '''将一个合法的数字字符串转成对应的数字'''
    L0=['0','1','2','3','4','5','6','7','8','9']
    L1=['a','b','c','d','e','f']
    L2=['A','B','C','D','E','F']
    n=0
    minus=0
    if s[0]=='-':
        s=s[1:]
        minus=1
    if type==0:
        s=s[1:]
        for i in s:
            n*=8
            for j in range(8):
                if L0[j]==i:
                    n+=j
                    break
    elif type==1:
        for i in s:
            n*=10
            for j in range(10):
                if L0[j]==i:
                    n+=j
                    break
    elif type==2:
        s=s[2:]
        for i in s:
            n*=16
            for j in range(10):
                if L0[j]==i:
                    n+=j
                    break
            for j in range(6):
                if L1[j]==i:
                    n+=j+10
                    break
    else:
        s=s[2:]
        for i in s:
            n*=16
            for j in range(10):
                if L0[j]==i:
                    n+=j
                    break
            for j in range(6):
                if L2[j]==i:
                    n+=j+10
                    break
    return n if minus==0 else -n
def num2bits(n:int,length:int=5,signed:bool=False)->str:
    '''将一个数字转成补码格式的字符串,length表示最后编码的长度(如果发生溢出将会提供错误编码),signed用于标记是否为有符号数,返回空字符串时表明编码出错'''
    s=''
    minus= True if n<0 else False
    if signed:
        length=length-1
        n=n if not minus else 2**length+n
    if (minus and not signed):
        return ''
    for i in range(length):
        f=n%2
        if f==0:
            s='0'+s
        else:
            s='1'+s
        n=n//2
    if n!=0:
        return ''
    if signed:
        if minus==False:
            s='0'+s
        else:
            s='1'+s
    return s
def labelCope(lines:list)->list:
    '''对于读入的字符串列表,将其转成代码列表lines(lines为元组,第一个元素为指令名字,后续元素按照rd,rs1,rs2,num的顺序排列)'''
    l=len(lines)
    i=0
    j=0
    while i<len(lines):
        if ':'in lines[i]:
            l_split=lines[i].split(':')
            del lines[i]
            if len(l_split)!=2:
                raise GrammarError('Too many targets in the code!')
            if l_split[0]=='':
                raise GrammarError('No target\'s name in the code!')
            l_split[0]=l_split[0].strip(' ')
            if not identifier(l_split[0]):
                raise GrammarError('Illegal label\'s name')
            if isRegisterName(l_split[0]):
                raise GrammarError('Illegal label\'s name')
            lines.insert(i,(l_split[0],-1))
            if l_split[1]!='':
                lines.insert(i+1,(l_split[1],j))
                j+=1
                i+=1
        else:
            line_t=lines[i]
            del lines[i]
            lines.insert(i,(line_t,j))
            j+=1
        i+=1
    i=0
    j=0
    labels=[]
    labelsName=[]
    while i<len(lines):
        if lines[i][1]!=-1:
            j+=1
            i+=1
        else:
            labels.append((lines[i][0],j))
            labelsName.append(lines[i][0])
            del lines[i]
    t=[]
    for i in lines:
        t.append(i[0])
    lines=t
    l=len(lines)
    insts=list(INST)
    for i in range(l):
        flag=0
        t=''
        for inst in insts:
            if flag==0:
                t=inst
            if lines[i].startswith(inst+' '):
                flag+=1
        if flag!=1:
            raise GrammarError('instruction name error')
        j=lines[i].split(t)
        if j[0].strip(' ')!='':
            raise GrammarError('instruction place error')
        lines[i]=(t,j[1].strip(' '))
    
    for i in range(l):
        inst=lines[i][0]
        inst_type=INST[inst][0]
        if inst_type==(3,0,0,0,0):
            t=lines[i][1].split(',')
            if len(t)!=3:
                raise GrammarError('Wrong grammar')
            for j in range(3):
                t[j]=t[j].strip(' ')
                if isRegisterName(t[j]):
                    t[j]=registerNameReplace(t[j])
                else:
                    raise GrammarError('register\'s name is illegal')
            lines[i]=(inst,t[0],t[1],t[2])
        elif inst_type==(2,0,1,0,0):
            t=lines[i][1].split(',')
            if len(t)!=3:
                raise GrammarError('Wrong grammar')
            for j in range(2):
                t[j]=t[j].strip(' ')
                if isRegisterName(t[j]):
                    t[j]=registerNameReplace(t[j])
                else:
                    raise GrammarError('register\'s name is illegal')
            t[2]=t[2].strip(' ')
            flag=0
            for label in labels:
                if t[2]==label[0]:
                    flag=1
                    t[2]=(label[1]-i)*4
                    break
            if flag==0:
                raise GrammarError('Label\'s name is illegal')
            lines[i]=(inst,t[0],t[1],t[2])
        elif inst_type==(2,1,0,0,0):
            t=lines[i][1].split(',')
            if len(t)==3:
                for j in range(2):
                    t[j]=t[j].strip(' ')
                    if isRegisterName(t[j]):
                        t[j]=registerNameReplace(t[j])
                    else:
                        raise GrammarError('register\'s name is illegal')
                t[2]=t[2].strip(' ')
                type=isNumber(t[2])
                if type==-1:
                    raise GrammarError('number is illegal')
                t[2]=getNumber(t[2],type)
                lines[i]=(inst,t[0],t[1],t[2])
            else:
                raise GrammarError('Wrong grammar')
        elif inst_type==(2,1,0,1,0):
            t=lines[i][1].split(',')
            if len(t)==2:
                t[0]=t[0].strip(' ')
                if isRegisterName(t[0]):
                    t[0]=registerNameReplace(t[0])
                else:
                    raise GrammarError('register\'s name is illegal')
                t[1]=t[1].strip(' ')
                left=t[1].count('(')
                right=t[1].count(')')
                if left!=1 or right!=1:
                    raise GrammarError('the amount of brackets is illegal')
                left=t[1].index('(')
                right=t[1].index(')')
                if left>right or right!=len(t[1])-1:
                    raise GrammarError('the place of brackets is illegal')
                t1=t[1][0:left]
                t2=t[1][left+1:right]
                t1=t1.strip(' ')
                t2=t2.strip(' ')
                type=isNumber(t1)
                if type==-1:
                    raise GrammarError('number is illegal')
                t1=getNumber(t1,type)
                if isRegisterName(t2):
                    t2=registerNameReplace(t2)
                else:
                    raise GrammarError('register\'s name is illegal')
                if inst in INST_S:
                    lines[i]=(inst,t2,t[0],t1)
                else:
                    lines[i]=(inst,t[0],t2,t1)
            else:
                raise GrammarError('Wrong grammar')
        elif inst_type==(1,1,0,0,0):
            t=lines[i][1].split(',')
            if len(t)==2:
                t[0]=t[0].strip(' ')
                if isRegisterName(t[0]):
                    t[0]=registerNameReplace(t[0])
                else:
                    raise GrammarError('register\'s name is illegal')
                t[1]=t[1].strip(' ')
                type=isNumber(t[1])
                if type==-1:
                    raise GrammarError('number is illegal')
                t[1]=getNumber(t[1],type)
                lines[i]=(inst,t[0],t[1])
            else:
                raise GrammarError('Wrong grammar')
        elif inst_type==(1,0,1,0,1):
            t=lines[i][1].split(',')
            if len(t)==2:
                t[0]=t[0].strip(' ')
                if isRegisterName(t[0]):
                    t[0]=registerNameReplace(t[0])
                else:
                    raise GrammarError('register\'s name is illegal')
                t[1]=t[1].strip(' ')
                flag=0
                for label in labels:
                    if t[1]==label[0]:
                        flag=1
                        t[1]=(label[1]-i)*4
                        break
                if flag==0:
                    raise GrammarError('Label\'s name is illegal')
                lines[i]=(inst,t[0],t[1])
            elif len(t)==1:
                t[0]=t[0].strip(' ')
                flag=0
                for label in labels:
                    if t[0]==label[0]:
                        flag=1
                        t[0]=(label[1]-i)*4
                        break
                if flag==0:
                    raise GrammarError('Label\'s name is illegal')
                lines[i]=(inst,1,t[0])
            else:
                raise GrammarError('Wrong grammar')
        else:
            raise GrammarError('Wrong grammar')
    #rd,rs1,rs2,imm
    return lines
def getBinary(lines)->list:
    '''将代码列表lines转成二进制机器码列表'''
    l=len(lines)
    for i in range(l):
        inst=lines[i][0]
        if inst in INST_R:
            s=INST[inst][2][2]
            s+=num2bits(lines[i][3],5,False)
            s+=num2bits(lines[i][2],5,False)
            s+=INST[inst][2][1]
            s+=num2bits(lines[i][1],5,False)
            s+=INST[inst][2][0]
        elif inst in INST_I:
            if INST[inst][1]==0:
                s=INST[inst][2][2]
                s+=num2bits(lines[i][3],5,False)
                s+=num2bits(lines[i][2],5,False)
                s+=INST[inst][2][1]
                s+=num2bits(lines[i][1],5,False)
                s+=INST[inst][2][0]
            else:
                s=num2bits(lines[i][3],12,True)
                s+=num2bits(lines[i][2],5,False)
                s+=INST[inst][2][1]
                s+=num2bits(lines[i][1],5,False)
                s+=INST[inst][2][0]
        elif inst in INST_S:
            imm=num2bits(lines[i][3],12,True)
            imm=imm[::-1]
            s=imm[:4:-1]+num2bits(lines[i][2],5,False)
            s+=num2bits(lines[i][1],5,False)
            s+=INST[inst][2][1]
            s+=imm[4::-1]+INST[inst][2][0]
        elif inst in INST_B:
            imm=num2bits(lines[i][3],13,True)
            imm=imm[::-1]
            s=imm[12]+imm[10:4:-1]+num2bits(lines[i][2],5,False)
            s+=num2bits(lines[i][1],5,False)
            s+=INST[inst][2][1]
            s+=imm[4:0:-1]+imm[11]+INST[inst][2][0]
        elif inst in INST_U:
            s=num2bits(lines[i][2],20,inst!='lui')
            s+=num2bits(lines[i][1],5,False)
            s+=INST[inst][2][0]
        else:
            imm=num2bits(lines[i][2],21,True)
            imm=imm[::-1]
            s=imm[20]+imm[10:0:-1]+imm[11]+imm[19:11:-1]
            s+=num2bits(lines[i][1],5,False)
            s+=INST[inst][2][0]
        if len(s)!=32:
                    raise GrammarError('the number is illegal')
        lines[i]=s
    return lines
def getHexadecimal(lines)->list:
    '''将代码列表lines转成十六进制机器码列表'''
    lines=getBinary(lines)
    nums=['0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f']
    codes=[]
    for i in lines:
        code=''
        for j in range(8):
            n=0
            for k in range(4):
                n*=2
                if i[j*4+k]=='1':
                    n+=1
            code+=nums[n]
        codes.append(code)
    return codes
def pretreat(f)->list:
    '''预处理阶段,读取文件并去除注释,返回有用的原始代码列表'''
    lines=f.readlines()
    l=len(lines)
    for i in range(l):
        t=lines[i]
        l1=len(t)
        for j in range(l1):
            if t[j]=='#':
                t=t[:j]
                break
        t=t.strip('\n')
        t=t.replace('\t','')
        t=t.replace('\r','')
        t=t.replace('\x0b','')
        t=t.replace('\x0c','')
        lines[i]=t.strip(' ')
    return [s for s in lines if s]
def run(code:str='',coped:str='',op:str='b'):
    '''在命令行输入参数也可以运行这个程序:python program.py(program_name) code(code_name) coped(result_name) op_type.op_type如下:
    b: 获取二进制机器码编码的txt文件
    h: 获取十六进制机器码编码的txt文件
    coe: 获取能导入vivado的IROM的coe文件
    '''
    l=len(sys.argv)
    if l!=4 and l!=1:
        print('输入的参数不符合要求,未执行命令')
        return
    if l==4:
        code,coped,op=sys.argv[1:]
    if code=='' or coped=='':
        print('未提供文件名称,未执行命令')
        return
    code+='.asm'
    
    try:
        with open(code,'r',encoding='utf-8') as f1:
            lines=pretreat(f1)
            lines=labelCope(lines)
            if op=='b':
                lines=getBinary(lines)
                coped+='.txt'
                with open(coped,'w') as f2:
                    for i in lines:
                        f2.write(i+'\n')
            elif op=='h':
                lines=getHexadecimal(lines)
                coped+='.txt'
                with open(coped,'w') as f2:
                    for i in lines:
                        f2.write(i+'\n')
            elif op=='coe':
                lines=getHexadecimal(lines)
                length=len(lines)
                for i in range(length):
                    if (i!=length-1):
                        lines[i]=lines[i]+','
                    else:
                        lines[i]=lines[i]+';'
                lines.insert(0,'memory_initialization_vector =')
                lines.insert(0,'memory_initialization_radix = 16;')
                coped+='.coe'
                with open(coped,'w') as f2:
                    for i in lines:
                        f2.write(i+'\n')
            else:
                print('指令错误,未执行命令')
    except FileNotFoundError:
        print('未找到汇编语言文件,未执行命令')
    except GrammarError as e:
        print('错误信息提示:'+e.msg)
if __name__=='__main__':
    print('1.py v0.1开始运行:')
    print('输入格式:python program.py(program_name) code(code_name) coped(result_name) op_type')
    run()
    print('运行结束')