import std.stdio;

import mcasm.main;
import mcasm.operand;
import mcasm.instruction;

void main()
{
	Program prog = new Program();
	prog.label["kek"] = 0;

	Register r0 = new Register("r0");

	prog.addInstruction(new Push(42));
	prog.addInstruction(new Mov(3, r0));
	prog.addInstruction(new Sub(-5, r0));
	prog.addInstruction(new Mul(12, r0));
	prog.addInstruction(new Mov(r0, new Memory("sp", null, 16)));
	prog.addInstruction(new Start("kek"));

	prog.compile();
	foreach(command; prog.commands)
	{
		with(command)
			writeln(x, " ", y, " ", z, " ", cmd);
	}
}
