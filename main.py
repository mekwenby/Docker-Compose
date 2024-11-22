import Mek_master as Mm

cdt = Mm.Create_Dir_tree()
for i in cdt.getDirList('.'):
    print(i)