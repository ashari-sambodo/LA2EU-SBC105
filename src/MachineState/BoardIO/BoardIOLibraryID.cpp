#include "BoardIOLibraryID.h"

#define LIBRARY_NAME        "LibBoardIO"
#define LIBRARY_VERSION     "1.0.0"
#define LIBRARY_BUILD_ID    1
#define LIBRARY_AUTHOR      "Heri Cahyono"

BoardIOLibraryID::BoardIOLibraryID()
{

}

string BoardIOLibraryID::getLibraryName()
{
    return LIBRARY_NAME;
}

string BoardIOLibraryID::getLibraryVersion()
{
    return LIBRARY_VERSION;
}

int BoardIOLibraryID::getLibraryBuildId()
{
    return LIBRARY_BUILD_ID;
}

string BoardIOLibraryID::getLibraryAuthor()
{
    return LIBRARY_AUTHOR;
}
