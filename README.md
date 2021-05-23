
#  Y86-64
## 模块说明
### fetch
###### 输入信号
时钟信号 sys_clk \
复位信号 rst_n \
模块使能信号 valid \
指令 inst\
PC计数值 val_P_reg\
###### 输出信号
指令代码 code\
功能码 fn\
寄存器标识A rA\
寄存器表示B rB\
常数值 val_C\
下一条指令地址 val_P\
执行模块结果写入地址 dst_E\
内存数据写入地址 dst_M \
取指模块，输入10字节的指令，指令计数器值，根据指令的code和function部分，输出不同指令对应的rA,rB以及常数等,同时计算出下条指令对应的计数地址。
当指令code为HALT和NOP时，rA，rB以及其他各项输出都为NONE，CPU不执行，并且若指令为HALT，CPU状态寄存器的状态置为HALT。\

![avatar](/image1.png)\
如上图，当指令code 为0x6时，rA，rB对应指令第二个字节，其余的比如val_C为NONE

### regfile
寄存器读写模块，输出取指模块输出的rA,rB对应寄存器值，同时当dst_E,dst_M不为NONE时，将val_E和val_M写入对应寄存器。
### execute
执行模块，当指令为OP时，对寄存器A和寄存器B的值根据功能码不同进行计算并输出，同时更新ZF,OF,CF三个状态。其他状态例如PUSH，POP，则是将PC计数值加八或者减八赋值给val_E。
### memory_access
访存管理模块，当指令需要对数据访存时，根据指令的不同，使能memory的读或者写，同时设置memory的读\写地址以及写入的数据。
### memory
存储分为两个部分，Instruction_memory存储指令，memory存储数据。

## 测试
![avatar](/image2.png)
测试代码如上图，经Modelsim仿真结果如下图
![avatar](/image3.png)
![avatar](/image4.png)
