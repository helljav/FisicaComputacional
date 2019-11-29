# Microsoft Developer Studio Generated NMAKE File, Format Version 4.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

!IF "$(CFG)" == ""
CFG=Untitled-1 - Win32 Debug
!MESSAGE No configuration specified.  Defaulting to Untitled-1 - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "Untitled-1 - Win32 Release" && "$(CFG)" !=\
 "Untitled-1 - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE on this makefile
!MESSAGE by defining the macro CFG on the command line.  For example:
!MESSAGE 
!MESSAGE NMAKE /f "Untitled-1.mak" CFG="Untitled-1 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Untitled-1 - Win32 Release" (based on\
 "Win32 (x86) Console Application")
!MESSAGE "Untitled-1 - Win32 Debug" (based on\
 "Win32 (x86) Console Application")
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

!IF  "$(CFG)" == "Untitled-1 - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\Untitled-1.exe"

CLEAN : 
	-@erase ".\Untitled-1.exe"
	-@erase ".\Untitled-1.obj"

# ADD BASE F90 /Ox /c /nologo
# ADD F90 /Ox /c /nologo
F90_PROJ=/Ox /c /nologo 
# ADD BASE RSC /l 0x80a /d "NDEBUG"
# ADD RSC /l 0x80a /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Untitled-1.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)/Untitled-1.pdb" /machine:I386 /out:"$(OUTDIR)/Untitled-1.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Untitled-1.obj"

"$(OUTDIR)\Untitled-1.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "Untitled-1 - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
OUTDIR=.
INTDIR=.

ALL : "$(OUTDIR)\Untitled-1.exe"

CLEAN : 
	-@erase ".\Untitled-1.exe"
	-@erase ".\Untitled-1.obj"
	-@erase ".\Untitled-1.ilk"
	-@erase ".\Untitled-1.pdb"

# ADD BASE F90 /Zi /c /nologo
# ADD F90 /Zi /c /nologo
F90_PROJ=/Zi /c /nologo /Fd"Untitled-1.pdb" 
# ADD BASE RSC /l 0x80a /d "_DEBUG"
# ADD RSC /l 0x80a /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
BSC32_FLAGS=/nologo /o"$(OUTDIR)/Untitled-1.bsc" 
BSC32_SBRS=
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)/Untitled-1.pdb" /debug /machine:I386\
 /out:"$(OUTDIR)/Untitled-1.exe" 
LINK32_OBJS= \
	"$(INTDIR)/Untitled-1.obj"

"$(OUTDIR)\Untitled-1.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
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

# Name "Untitled-1 - Win32 Release"
# Name "Untitled-1 - Win32 Debug"

!IF  "$(CFG)" == "Untitled-1 - Win32 Release"

!ELSEIF  "$(CFG)" == "Untitled-1 - Win32 Debug"

!ENDIF 

################################################################################
# Begin Source File

SOURCE=".\Untitled-1.f90"

!IF  "$(CFG)" == "Untitled-1 - Win32 Release"

F90_MODOUT=\
	"var"


"$(INTDIR)\Untitled-1.obj" : $(SOURCE) "$(INTDIR)"
   $(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "Untitled-1 - Win32 Debug"

F90_MODOUT=\
	"var"


"$(INTDIR)\Untitled-1.obj" : $(SOURCE) "$(INTDIR)"
   $(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

# End Source File
# End Target
# End Project
################################################################################
