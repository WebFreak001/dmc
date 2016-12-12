module mcasm.instruction;

import mcasm.main;
import mcasm.operand;
import mcasm.annotation;

interface Instruction
{
	void compile(Program prog);
}

mixin template MathInstruction(alias op)
{
	Operand src;
	Operand dst;

	this(Operand src, Operand dst)
	{
		this.src = src;
		this.dst = dst;
	}

	void compile(Program prog)
	{
		string srcStr = src.toString(prog, 0);
		string dstStr = dst.toString(prog, 1);
		prog.addCommand("scoreboard players operation " ~ dstStr ~ " val " ~ op ~ " " ~ srcStr ~ " val");
	}
}
class Mov : Instruction
{
	mixin MathInstruction!"=";
}
class Swp : Instruction
{
	mixin MathInstruction!"><";
}
class Min : Instruction
{
	mixin MathInstruction!"<";
}
class Max : Instruction
{
	mixin MathInstruction!">";
}
class Add : Instruction
{
	mixin MathInstruction!"+=";
}
class Sub : Instruction
{
	mixin MathInstruction!"-=";
}
class Mul : Instruction
{
	mixin MathInstruction!"*=";
}
class Div : Instruction
{
	mixin MathInstruction!"/=";
}
class Mod : Instruction
{
	mixin MathInstruction!"%=";
}

class Start : Instruction
{
	string label;
	this(string label)
	{
		this.label = label;
	}

	void compile(Program prog)
	{
		Command cmd = new Command("blockdata %s {auto:true}");
		cmd.annotations = [new Label(label)];
		prog.addCommand(cmd);
	}
}
class End : Instruction
{
	void compile(Program prog)
	{
		prog.addCommand(cast(Command)null); //places a stone
	}
}

class Push : Instruction
{
	Operand val;
	this(Operand val)
	{
		this.val = val;
	}

	void compile(Program prog)
	{
		(new Mov(val, new Memory("sp"))).compile(prog);
		(new Sub(new Constant(1), new Register("sp"))).compile(prog);
	}
}
class Pop : Instruction
{
	Operand val;
	this(Operand val)
	{
		this.val = val;
	}

	void compile(Program prog)
	{
		(new Add(new Constant(1), new Register("sp"))).compile(prog);
		(new Mov(new Memory("sp"), val)).compile(prog);
	}
}
