function ret=doocsnames_test01(parentName)

init_matlab_and_libs

if nargin<1
    parentName='PITZ.UTIL/*/*/*';
end

ret=doocs_names(parentName);

end
