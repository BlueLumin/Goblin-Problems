# Handles opening links through RichTextLabel nodes.
extends RichTextLabel


func meta_clicked(meta):
	OS.shell_open(meta)
