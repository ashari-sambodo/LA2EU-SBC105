#pragma once

#include <string>

using namespace std;

class BoardIOLibraryID
{
public:
    BoardIOLibraryID();

    static string getLibraryName();
    static string getLibraryVersion();
    static int getLibraryBuildId();
    static string getLibraryAuthor();
};

