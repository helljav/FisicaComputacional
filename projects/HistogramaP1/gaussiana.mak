# Microsoft Developer Studio Generated NMAKE File, Format Version 4.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=gaussiana - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to gaussiana - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "gaussiana - Win32 Release" && "$(CFG)" !=\
 "gaussiana - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "gaussiana.mak" CFG="gaussiana - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "gaussiana - Win32 Release" (based on\
 "Win32 (x86) Console Application")
!MESSAGE "gaussiana - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 
################################################################################
# Begin Project
F90=fl32.exe
RSC=rc.exe

!IF  "$(CFG)" == "gaussiana - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\gaussiana.exe"

CLEAN : 
	-@erase ".\gaussiana.exe"
	-@erase ".\gaussiana.obj"

# ADD BASE F90 /Ox /c /nologo
# ADD F90 /Ox /c /nologo
F90_PROJ=/Ox /c /nologo 
# ADD BASE RSC /l 0x80a /d "NDEBUG"
# ADD RSC /l 0x80a /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/gaussiana.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/gaussiana.pdb" /machine:I386 /out:"$(OUTDIR)/gaussiana.exe" 
LINK32_OBJS= \
	"$(INTDIR)/gaussiana.obj"

"$(OUTDIR)\gaussiana.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "gaussiana - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\gaussiana.exe"

CLEAN : 
	-@erase ".\gaussiana.exe"
	-@erase ".\gaussiana.obj"
	-@erase ".\gaussiana.ilk"
	-@erase ".\gaussiana.pdb"

# ADD BASE F90 /Zi /c /nologo
# ADD F90 /Zi /c /nologo
F90_PROJ=/Zi /c /nologo /Fd"gaussiana.pdb" 
# ADD BASE RSC /l 0x80a /d "_DEBUG"
# ADD RSC /l 0x80a /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/gaussiana.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/gaussiana.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/gaussiana.exe" 
LINK32_OBJS= \
	"$(INTDIR)/gaussiana.obj"

"$(OUTDIR)\gaussiana.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.for.obj:
   $(F90) $(F90_PROJ) $<  

.f.obj:
   $(F90) $(F90_PROJ) $<  

.f90.obj:
   $(F90) $(F90_PROJ) $<  

################################################################################
# Begin Target

# Name "gaussiana - Win32 Release"
# Name "gaussiana - Win32 Debug"

!IF  "$(CFG)" == "gaussiana - Win32 Release"

!ELSEIF  "$(CFG)" == "gaussiana - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=.\gaussiana.f90
DEP_F90_GAUSS=\
	".\var.mod"\
	

!IF  "$(CFG)" == "gaussiana - Win32 Release"

F90_MODOUT=\
	"var
"


"$(INTDIR)\gaussiana.obj" : $(SOURCE) $(DEP_F90_GAUSS) "$(INTDIR)"
   $(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "gaussiana - Win32 Debug"

F90_MODOUT=\
	"var
"


"$(INTDIR)\gaussiana.obj" : $(SOURCE) $(DEP_F90_GAUSS) "$(INTDIR)"
   $(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
