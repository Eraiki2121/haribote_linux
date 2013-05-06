SECTIONS
{
	. = 0x00280000;

	.text : AT(0)
	{
		*(.text)
	}

	.rodata : AT( LOADADDR(.text) + SIZEOF(.text) )
	{
		*(.rodata)
	}

	.data : AT( LOADADDR(.rodata) + SIZEOF(.rodata) )
	{
		*(.data)
	}

	.bss :
	{
		*(.bss)
	}

	.eh_frame :
	{
		*(.eh_frame)
	}
}
