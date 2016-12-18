module mcasm.instruction;

import std.conv;
import mcasm.main;
import mcasm.operand;
import mcasm.annotation;

abstract class Instruction
{
	abstract void compile(Program prog);

	void compile(Program prog, Annotation conditionalTo)
	{
		if(conditionalTo)
			throw new Exception("Instruction " ~ this.stringof ~ " cannot be conditional");
		else
			this.compile(prog);
	}
}

class MathInstruction(alias op, alias constOp = null) : Instruction
{
	Operand src;
	Operand dst;

	this(Operand src, Operand dst)
	{
		this.src = src;
		this.dst = dst;
	}
	this(int src, Operand dst)
	{
		this.src = new Immediate(src);
		this.dst = dst;
	}

	override void compile(Program prog)
	{
		string dstStr = dst.toString(prog, 1);

		if(constOp != null && cast(Immediate)src)
		{
			string op;
			int val = (cast(Immediate)src).val;

			if(val < 0 && constOp == "add")
			{
				val = -val;
				op = "sub";
			}
			else if(val < 0 && constOp == "sub")
			{
				val = -val;
				op = "add";
			}
			else
			{
				op = constOp;
			}

			prog.addCommand("scoreboard players " ~ op ~ " " ~ dstStr ~ " val " ~ val.to!string);
		}
		else
		{
			string srcStr = src.toString(prog, 0);
			prog.addCommand("scoreboard players operation " ~ dstStr ~ " val " ~ op ~ " " ~ srcStr ~ " val");
		}
	}
}
alias Mov = MathInstruction!("=", "set");
alias Swp = MathInstruction!"><";
alias Min = MathInstruction!"<";
alias Max = MathInstruction!">";
alias Add = MathInstruction!("+=", "add");
alias Sub = MathInstruction!("-=", "sub");
alias Mul = MathInstruction!"*=";
alias Div = MathInstruction!"/=";
alias Mod = MathInstruction!"%=";

class Start : Instruction
{
	string label;
	this(string label)
	{
		this.label = label;
	}

	override void compile(Program prog)
	{
		Command cmd = new Command("blockdata %s {auto:true}");
		cmd.annotations = [new Label(label)];
		prog.addCommand(cmd);
	}
}
class End : Instruction
{
	override void compile(Program prog)
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
	this(int val)
	{
		this.val = new Immediate(val);
	}

	override void compile(Program prog)
	{
		(new Mov(val, new Memory("sp"))).compile(prog);
		(new Sub(new Immediate(1), new Register("sp"))).compile(prog);
	}
}
class Pop : Instruction
{
	Operand val;
	this(Operand val)
	{
		this.val = val;
	}
	this(int val)
	{
		this.val = new Immediate(val);
	}

	override void compile(Program prog)
	{
		(new Add(new Immediate(1), new Register("sp"))).compile(prog);
		(new Mov(new Memory("sp"), val)).compile(prog);
	}
}
