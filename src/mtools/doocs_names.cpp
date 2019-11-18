#include <mex.h>
#include <string.h>
#include <eq_client.h>
#include <zn_tools_internal.h>

void mexFunction( int /*a_nNumOuts*/, mxArray *a_Outputs[],
                  int a_nNumInps, const mxArray*a_Inputs[] )
{
    if(a_nNumInps<1 || !mxIsChar(a_Inputs[0])){
        mexErrMsgTxt("Not correct argument. String argument should be provided");
        return; // return is not needed, because  mexErrMsgTxt throws exception
    }

    const size_t unInputStrLen = mxGetNumberOfElements(a_Inputs[0]);
    if(unInputStrLen<1){
        mexErrMsgTxt("Not correct argument. Non empty string argument should be provided");
        return; // return is not needed, because  mexErrMsgTxt throws exception
    }

    size_t unBufLen = unInputStrLen + 16;
    char* pcDoocsAddress = static_cast<char*>(alloca(unBufLen));

    if( mxGetString( a_Inputs[0], pcDoocsAddress, unBufLen )  ){
        mexErrMsgTxt("Unable to get the string!\n");
        return; // return is not needed, because  mexErrMsgTxt throws exception
    }

    int nNumber = 0;
    char *pcTemp=NEWNULLPTR2, *pcOccurance = strchr(pcDoocsAddress,'/');

    while(pcOccurance)
    {
        pcTemp = pcOccurance + 1;
        ++nNumber;
        pcOccurance = strchr(pcTemp,'/');
    }

    if(nNumber>3){
        mexErrMsgTxt("Wrong format!\n");
        return; // return is not needed, because  mexErrMsgTxt throws exception
    }

    size_t unStrLen = strlen(pcDoocsAddress);

    if(pcDoocsAddress[unStrLen-1]!='/')
    {
        pcDoocsAddress[unStrLen++] = '/';
        ++nNumber;
    }

    if(nNumber==3)pcDoocsAddress[unStrLen++] = '*';


    nNumber = 3 - nNumber;
    for(int i(0); i < nNumber;++i)
    {
        pcDoocsAddress[unStrLen++] = '*';
        pcDoocsAddress[unStrLen++] = '/';
    }

    pcDoocsAddress[unStrLen++] = 0;

    EqAdr aAdr;
    aAdr.adr(pcDoocsAddress);

    EqData aData;
    aData.init();

    EqCall aCall;
    aCall.names(&aAdr,&aData);

    size_t length = static_cast<size_t>(aData.length());
    if(length<1){
        mexErrMsgTxt("No entry exist!\n");
        return; // return is not needed, because  mexErrMsgTxt throws exception
    }

    a_Outputs[0] = mxCreateCellMatrix(1,length);
    if(!a_Outputs[0]){
        mexErrMsgTxt("Low memory!\n");
        return; // return is not needed, because  mexErrMsgTxt throws exception
    }

    mxArray* stringCell;

    USTR* pUSTR;
    for(size_t i(0); i < length; ++i){
        pUSTR = aData.get_ustr(static_cast<int>(i));
        if(pUSTR && pUSTR->str_data.str_data_val){
            stringCell = mxCreateString(pUSTR->str_data.str_data_val);
            if(!stringCell){
                mexErrMsgTxt("Low memory!\n");
                return; // return is not needed, because  mexErrMsgTxt throws exception
            }
            mxSetCell(a_Outputs[0],i,stringCell);
        }
    }  // for(size_t i(0); i < length; ++i){
}
