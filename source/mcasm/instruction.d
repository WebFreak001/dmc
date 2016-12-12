module mcasm.instruction;

import std.conv;
import mcasm.main;
import mcasm.operand;
import mcasm.annotation;

interface Instruction
{
	void compile(Program prog);
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
		this.src = new Constant(src);
		this.dst = dst;
	}

	void compile(Program prog)
	{
		string dstStr = dst.toString(prog, 1);

		if(constOp != null && cast(Constant)src)
		{
			string op;
			int val = (cast(Constant)src).val;

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
	this(int val)
	{
		this.val = new Constant(val);
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
	this(int val)
	{
		this.val = new Constant(val);
	}

	void compile(Program prog)
	{
		(new Add(new Constant(1), new Register("sp"))).compile(prog);
		(new Mov(new Memory("sp"), val)).compile(prog);
	}
}
