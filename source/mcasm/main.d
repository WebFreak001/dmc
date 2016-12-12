module mcasm.main;

import std.container : SList;
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

	void compile()
	{
		foreach(ins; instructions)
			ins.compile(this);
	}
}
