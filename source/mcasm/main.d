module mcasm.main;

import std.conv;
import std.string;
import mcasm.annotation;
import mcasm.instruction;

enum BlockDirection
{
	east,
	south,
	west,
	noth
}

class Command
{
	string cmd;
	Annotation conditionalTo;
	Annotation[] annotations;

	int x, y, z;
	BlockDirection direction;

	this(string cmd, Annotation conditionalTo = null)
	{
		this.cmd = cmd;
		this.conditionalTo = conditionalTo;
	}

	void finalize(Program prog, int self)
	{
		foreach(i, anno; annotations)
		{
			string insertion = anno.finalize(prog, self);
			long idx = cmd.indexOf("%s");

			cmd = cmd[0 .. idx] ~ insertion ~ cmd[idx + 2 .. $];
		}
	}
}

class Program
{
	Instruction[] instructions;
	Command[] commands;
	int[string] label;
	int[] constants;

	void addCommand(string cmd, Annotation conditionalTo = null)
	{
		commands ~= new Command(cmd, conditionalTo);
	}

	void addCommand(Command cmd)
	{
		commands ~= cmd;
	}

	void addInstruction(Instruction ins)
	{
		instructions ~= ins; //TODO directly compile here?
	}

	void addConstant(int val)
	{
		constants ~= val;
	}

	void compile()
	{
		foreach(ins; instructions)
			ins.compile(this);

		foreach(i, cmd; commands)
			cmd.finalize(this, cast(int)i);

		Command[] initConsts = new Command[constants.length];
		foreach(i, val; constants)
			initConsts[i] = new Command("scoreboard players set const" ~ val.to!string ~ " val " ~ val.to!string);

		commands = initConsts ~ commands;
	}
}
