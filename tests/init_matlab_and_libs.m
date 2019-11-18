

try
    thisFilePath = matlab.desktop.editor.getActiveFilename;
    %[fileDir,fileName]=fileparts(thisFilePath);
    [fileDir]=fileparts(thisFilePath);
    %fprintf('thisFilePath=%s\nfileDir=%s, fileName=%s\n',thisFilePath,fileDir,fileName);

    if ispc
        pathToSys='\..\sys\';
        finalMexDir='\mbin';
        ldLibraryPathKey='Path';
        additionalLibraryPath='D:\davit\dev\doocs-all\sys\win_msc_x64\dll;D:\davit\dev\doocs-all\udoocs\contrib\wlac\sys\win_msc_x64\dll;';
        if strcmp(computer,'PCWIN64')
            lsbCodeName='win_msc_x64';
        else
            lsbCodeName='win_msc_Win32';
        end
    else
        pathToSys='/../sys/';
        finalMexDir='/lib';
        ldLibraryPathKey='LD_LIBRARY_PATH';
        additionalLibraryPath='/afs/ifh.de/group/pitz/doocs/lib:';
        lsbCodeName=evalc('retFromSysCall=unix(''lsb_release -c | cut -f 2'');');
        if retFromSysCall % we have mac book
            % fix lsb_codenale
            ldLibraryPathKey='DYLD_LIBRARY_PATH';
            lsbCodeName = 'mac';
        end
        clear retFromSysCall;
    end

    %dirToCd=[fileDir '/../sys/' lsbCodeName];
    dirToCd=strcat(fileDir, pathToSys,lsbCodeName,finalMexDir);

    oldCurDir=cd(dirToCd);
    mexFileDir=cd(oldCurDir);

    addpath(mexFileDir);
    oldLdLibraryPath=getenv(ldLibraryPathKey);
    valueShouldBeSet=int32(1);
    if isempty(oldLdLibraryPath)
        oldLdLibraryPath='';
    else
        strFindRet=strfind(oldLdLibraryPath,additionalLibraryPath);
        if ~isempty(strFindRet)
            valueShouldBeSet=int32(0);
        end
        clear strFindRet;
    end

    if valueShouldBeSet
        newLdLibraryPath=strcat(additionalLibraryPath,oldLdLibraryPath);
        setenv(ldLibraryPathKey,newLdLibraryPath);
    end

    doocsEns=getenv('ENSHOST');
    if isempty(doocsEns)
        setenv('ENSHOST','doocsens1:doocsens2');
    end
catch exceptn1
    fprintf(2,'exception thrown!\n');
    disp(exceptn1);
    clear exceptn1;
end

clear additionalLibraryPath;
clear dirToCd;
clear fileDir;
clear finalMexDir;
clear ldLibraryPathKey;
clear lsbCodeName;
clear mexFileDir;
clear oldCurDir;
clear oldLdLibraryPath;
clear pathToSys;
clear thisFilePath;
clear valueShouldBeSet;
clear doocsEns;
