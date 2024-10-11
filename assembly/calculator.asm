#��ǰ����
lui s0,0xFFFFF
MAIN:
	lw s1,0x78(s0)
	sw s1,0x60(s0)
	lw s1,0x70(s0) #��ȡB
	srli s2,s1,8
	andi s2,s2,0xFF #��ȡA
	srli s3,s1,21
	andi s3,s3,0xFF #��ȡ������
	andi s1,s1,0xFF #��ȡB
	addi t1,x0,0
	#�жϲ���������Ӧ�ľ������
	beq s3,t1,CALC0
	addi t1,t1,1
	beq s3,t1,CALC1
	addi t1,t1,1
	beq s3,t1,CALC2
	addi t1,t1,1
	beq s3,t1,CALC3
	addi t1,t1,1
	beq s3,t1,CALC4
	addi t1,t1,1
	beq s3,t1,CALC5
END:
	jal x0,MAIN #����ѭ��
CALC0:#ֱ�����0
	sw x0,0(s0)
	jal x0,END	
CALC1:#����ӷ��ļ�����
	srli t1,s1,4
	andi t2,s1,0xF
	srli t3,s2,4
	andi t4,s2,0xF
	add t1,t1,t3 #�������ּ���
	add t2,t2,t4 #С�����ּ���
	addi t0,x0,10
	bge t2,t0,L1 #�ж�С�������Ƿ�Ҫ��λ
R1:
	addi t3,x0,10
	bge t1,t3,L2 #���������ֵ�16����ת��Ϊ10����
R2:  #���������
	slli t1,t1,16
	add t1,t1,t2 #���ݴ���
	sw t1,0(s0)
	jal x0,END
L1: #С����λ
	addi t2,t2,-10
	addi t1,t1,1
	jal x0,R1
L2: #����ת10����
	addi t4,x0,0 #��Ϊ������λ
	addi t5,t1,0 #��������ֵ
	bge t1,t3,L21
	jal x0,R2
L21: #��ʼ����ת10����
	addi t4,t4,1
	addi t5,t5,-10
	bge t5,t3,L21
	addi t1,t5,0
	slli t4,t4,4
	add t1,t1,t4
	jal x0,R2	
CALC2:
	addi s5,x0,0
   	addi t6,x0,10
    	blt s1,s2,L3 #���ֽϴ����ͽ�С��
    	andi t0,s1,0xF
    	srli t1,s1,4
    	andi t2,s2,0xF
    	srli t3,s2,4
    	#��Ӧ�ϴ����ͽ�С�����������ֺ�С������
    	jal x0,L4
L3:
    	andi t0,s2,0xF
    	srli t1,s2,4
    	andi t2,s1,0xF
    	srli t3,s1,4
L4:
    	sub t0,t0,t2 #С��λ
    	sub t1,t1,t3 #����λ
L5:
    	bge t0,x0,L6 #С��λ�Ǹ�ʱ���账������ת
    	addi t0,t0,10
    	addi t1,t1,-1
    	jal x0,L5
L6:
    	blt t1,t6,R6 #����λ����ת10���Ƶ�ʱ����ת
   	addi t1,t1,-10
    	addi s5,s5,1
    	jal x0,L6
R6:
    	slli s5,s5,4
    	add s5,s5,t1
    	slli s5,s5,16
   	add s5,s5,t0 #���ݴ���
	sw s5,0(s0)
    	jal x0,END		
CALC3:
	addi t0,x0,9
	srli t2,s2,4 #A����������
	andi t1,s2,0xF #A��С������
	addi t3,x0,0
	addi t4,x0,0
	addi t5,x0,0 #�����ڱ���������λ����
	bge t0,t2,L7 #�����账��������λ����ת
	addi t2,t2,-10
	addi t3,t3,1
L7: #ִ������
	bge x0,s1,R7 #����ִ����ϣ���ת
	slli t5,t5,1
	bge t0,t5,L71 #�ж��Ƿ񳬳�
	addi t5,t5,-10
L71:
	slli t4,t4,1
	bge t0,t4,L72 #�ж��Ƿ��λ
	addi t4,t4,-10
	addi t5,t5,1
L72:
	slli t3,t3,1
	bge t0,t3,L73 #�ж��Ƿ��λ
	addi t3,t3,-10
	addi t4,t4,1
L73:
	slli t2,t2,1
	bge t0,t2,L74 #�ж��Ƿ��λ
	addi t2,t2,-10
	addi t3,t3,1
L74:
	slli t1,t1,1
	bge t0,t1,L75 #�ж��Ƿ��λ
	addi t1,t1,-10
	addi t2,t2,1
L75:
	addi s1,s1,-1 #һ���������
	jal x0,L7
R7:
	slli t5,t5,28
	add t1,t1,t5
	slli t4,t4,24
	add t1,t1,t4
	slli t3,t3,20
	add t1,t1,t3
	slli t2,t2,16
	add t1,t1,t2 #���ݴ���
	sw t1,0(s0)
	jal x0,END	
CALC4:
	addi t0,x0,9
	srli t2,s2,4 #A����������
	andi t3,s2,0xF #A��С������
	addi t1,x0,0
	addi t4,x0,0
	addi t5,x0,0
	addi t6,x0,0 #��Щ�Ĵ������ڴ����λ����
	bge t0,t2,L8 #����������λ
	addi t2,t2,-10
	addi t1,t1,1
L8:
	bge x0,s1,R8
	srli t6,t6,1
	andi t0,t5,1
	beq t0,x0,L81 #��2����Ľ�������Ƿ�����λ
	addi t6,t6,5
L81:
	srli t5,t5,1
	andi t0,t4,1
	beq t0,x0,L82 #��2����Ľ�������Ƿ�����λ
	addi t5,t5,5
L82:
	srli t4,t4,1
	andi t0,t3,1
	beq t0,x0,L83 #��2����Ľ�������Ƿ�����λ
	addi t4,t4,5
L83:
	srli t3,t3,1
	andi t0,t2,1
	beq t0,x0,L84 #��2����Ľ�������Ƿ�����λ
	addi t3,t3,5
L84:
	srli t2,t2,1
	andi t0,t1,1
	beq t0,x0,L85 #��2����Ľ�������Ƿ�����λ
	addi t2,t2,5
L85:
	srli t1,t1,1
	addi s1,s1,-1
	jal x0,L8
R8:
	slli t1,t1,20
	add t6,t6,t1
	slli t2,t2,16
	add t6,t6,t2
	slli t3,t3,12
	add t6,t6,t3
	slli t4,t4,8
	add t6,t6,t4
	slli t5,t5,4
	add t6,t6,t5 #���ݴ���
	sw t6,0(s0)
	jal x0,END	
CALC5:
	slli t1,s2,24
	slli t0,s1,16
	add t1,t1,t0
	slli t0,s2,8
	add t1,t1,t0
	add t1,t1,s1 #��������
	addi t2,x0,5
L9:
	lui t5,0x356
	addi t5,t5,0x7e0
	addi t6,x0,0
L10:
    	bge t6,t5,R10
    	addi t6,t6,1
    	jal x0,L10
R10:
	lw t6,0x78(s0)
	sw t6,0x60(s0)
	sw t1,0(s0) #�������
	andi t0,t1,1
	srli t3,t1,1
	andi t3,t3,1
	xor t0,t0,t3
	srli t3,t1,20
	andi t3,t3,1
	xor t0,t0,t3
	srli t3,t1,31
	andi t3,t3,1
	xor t0,t0,t3
	slli t1,t1,1
	add t1,t1,t0 #LSFR����
	lw s3,0x70(s0) #�������ı��򷵻�
	srli s3,s3,21
	andi s3,s3,0xFF
	beq s3,t2,L9
	jal x0,END
