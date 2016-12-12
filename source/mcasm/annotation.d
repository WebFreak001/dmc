module mcasm.annotation;

import std.conv;
import mcasm.main;

interface Annotation
{
	string toString(Program prog, int self);
}

class Label : Annotation
{
	string label;
	this(string label)
	{
		this.label = label;
	}

	string toString(Program prog, int self)
	{
		int pos = prog.label[this.label];
		with(prog.commands[pos])
		{
			return x.to!string ~ " " ~ y.to!string ~ " " ~ z.to!string;
		}
	}
}

class Position : Annotation
{
	int pos;
	this(int pos)
	{
		this.pos = pos;
	}

	string toString(Program prog, int self)
	{
		with(prog.commands[this.pos])
		{
			return x.to!string ~ " " ~ y.to!string ~ " " ~ z.to!string;
		}
	}
}
