module mcasm.annotation;

import std.conv;
import mcasm.main;

interface Annotation
{
	string finalize(Program prog, int self);
}

class Label : Annotation
{
	string label;
	this(string label)
	{
		this.label = label;
	}

	string finalize(Program prog, int self)
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

	string finalize(Program prog, int self)
	{
		with(prog.commands[this.pos])
		{
			return x.to!string ~ " " ~ y.to!string ~ " " ~ z.to!string;
		}
	}
}
