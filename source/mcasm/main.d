module mcasm.main;

import std.conv;
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
	bool conditional;
	Annotation[] annotations;

	int x, y, z;
	BlockDirection direction;

	this(string cmd, bool conditional = false)
	{
		this.cmd = cmd;
		this.conditional = conditional;
	}
}

class Program
{
	Instruction[] instructions;
	Command[] commands;
	int[string] label;
	int[] constants;

	void addCommand(string cmd, bool conditional = false)
	{
		commands ~= new Command(cmd, conditional);
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

		Command[] initConsts = new Command[constants.length];
		foreach(i, val; constants)
			initConsts[i] = new Command("scoreboard players set const" ~ val.to!string ~ " val " ~ val.to!string);

		commands = initConsts ~ commands;
	}
}
