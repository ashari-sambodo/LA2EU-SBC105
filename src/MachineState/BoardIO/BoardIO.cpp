#include "BoardIO.h"
//#include <QtDebug>

BoardIO::BoardIO(QObject *parent)
    : QObject(parent)
{
}

void BoardIO::setI2C(I2CCom *pObject)
{
    pI2c = pObject;
}

int BoardIO::addModule(ClassDriver *pModule)
{
    //    printf("BoardIO::addModule %s\n", idStr.toStdString().c_str());
    //    fflush(stdout);

    pModules.push_back(pModule);
    return pModules.count();
}

void BoardIO::worker(int parameter)
{
    Q_UNUSED(parameter)
    //    qDebug()<<"Worker::workerPoll get called from?: "<<QThread::currentThreadId();

    //send out queque
    pI2c->sendOutQueue();

    //POLLING_DATA
    foreach (ClassDriver* board, pModules){
        //#ifndef NO_PRINT_DEBUG
        //        printf("board address %02X\n", board->address());
        //        fflush(stdout);
        //#endif
        if(board->commStatus() == ClassDriver::I2C_COMM_OK){
            //POLLING_DATA
            if(board->polling() != 0){
                board->setCommStatus(ClassDriver::I2C_COMM_ERROR);
            }
        }else{
            //TEST_COMMUNICATION
            if(board->testComm() == 0){
                //THEN_INIT_OR_RE_INITIALIZING
                if(board->init() == 0){
                    //MODULE_HAS_RESPONSED
                    board->setCommStatus(ClassDriver::I2C_COMM_OK);
                }
            }else {
                board->setCommStatus(ClassDriver::I2C_COMM_ERROR);
                //CLEAR_BUFFER
                board->clearRegBuffer();
            }
        }

        //INCREASE_COMM_ERROR_COUNT
        if(board->commStatus() == ClassDriver::I2C_COMM_ERROR){
            int errorCount = board->errorComCount();
            errorCount = errorCount + 1;
            //#ifndef NO_PRINT_DEBUG
            //            printf("errorCount %d\n", errorCount);
            //            fflush(stdout);
            //#endif
            board->setErrorComCount(errorCount);
        }
        //CLEAR_COMM_ERROR_COUNT
        else if (board->commStatus() == ClassDriver::I2C_COMM_OK) {
            //IF_ERROR_COUNT_MORE_THAN_ZERO
            if(board->errorComCount()){
                board->setErrorComCount(0);
            }

            //#ifndef NO_PRINT_DEBUG
            //            printf("errorCount ClassDriver::I2C_COMM_OK\n");
            //            fflush(stdout);
            //#endif
        }

        //#ifndef NO_PRINT_DEBUG
        //        printf("CommStatus %d\n", board->commStatus());
        //        fflush(stdout);
        //#endif
    }
    //    abort();
}
