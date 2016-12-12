module mcasm.operand;

import std.conv;
import std.format;
import mcasm.main;

interface Operand
{
	string toString(Program prog, int operandNum);
}

class Constant : Operand
{
	int val;
	this(int val)
	{
		this.val = val;
	}

	string toString(Program prog, int opNum)
	{
		return val.to!string;
	}
}

class Register : Operand
{
	string reg;
	this(string reg)
	{
		this.reg = reg;
	}

	string toString(Program prog, int opNum)
	{
		return reg;
	}
}

const(string) movAddrTmp = "execute @e[score_addr_min=1] ~ ~ ~ scoreboard players operation @e[r=0] tmp = @e[r=0] addr";
const(string) subRegTmp = "execute @e[score_addr_min=1] ~ ~ ~ scoreboard players operation @e[r=0] tmp -= %s val";
const(string) subImmTmp = "scoreboard players remove @e[score_addr_min=1] tmp %d";
class Memory : Operand
{
	string base;
	string index;
	int offset;

	this(string base = null, string index = null, int offset = 0)
	{
		this.base = base;
		this.index = index;
		this.offset = offset;
	}

	string toString(Program prog, int opNum)
	{
		prog.addCommand(movAddrTmp);

		if(base)
			prog.addCommand(format(subRegTmp, base));
		if(index)
			prog.addCommand(format(subRegTmp, index));
		if(offset)
			prog.addCommand(format(subImmTmp, offset));

		return "@e[score_addr_min=1,score_tmp_min=0,score_tmp=0]";
	}
}
