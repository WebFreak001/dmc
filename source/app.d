import std.stdio;

import mcasm.main;
import mcasm.operand;
import mcasm.instruction;

void main()
{
	Program prog = new Program();
	prog.label["kek"] = 0;
	prog.addInstruction(new Push(new Constant(3)));
	prog.addInstruction(new Mov(new Constant(3), new Register("r0")));
	prog.addInstruction(new Sub(new Constant(-5), new Register("r0")));
	prog.addInstruction(new Mul(new Constant(12), new Register("r0")));
	prog.addInstruction(new Mov(new Register("r0"), new Memory("sp")));
	prog.addInstruction(new Start("kek"));

	prog.compile();
	foreach(command; prog.commands)
	{
		with(command)
			writeln(x, " ", y, " ", z, " ", cmd);
	}
}
