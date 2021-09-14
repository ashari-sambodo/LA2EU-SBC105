#include "RegisterExternalResources.h"
#include <QDir>
#include <QResource>

RegisterExternalResources::RegisterExternalResources(QObject *parent) : QObject(parent)
{
#ifdef __arm__
    m_resourcePath = "/usr/local/share/QuickTourAsset.rcc";
#else
    m_resourcePath = QDir::currentPath() + "/BscQuickTourAssets.rcc";
#endif
}

bool RegisterExternalResources::importResource()
{
    /// Import external qrc
    return QResource::registerResource(m_resourcePath);
}

bool RegisterExternalResources::releaseResource()
{
    return QResource::unregisterResource(m_resourcePath);
}

bool RegisterExternalResources::setResourcePath(short pathCode)
{
    switch(pathCode){
    case Resource_QuickTourAsset:
#ifdef __arm__
        m_resourcePath = "/usr/local/share/QuickTourAsset.rcc";
#else
        m_resourcePath = QDir::currentPath() + "/BscQuickTourAssets.rcc";
#endif
        m_pathCode = pathCode;
        break;
    case Resource_General:
#ifdef __arm__
        m_resourcePath = "/usr/local/share/QtGeneralQResource.rcc";
#else
        m_resourcePath = QDir::currentPath() + "/QtGeneralQResource.rcc";
#endif
        m_pathCode = pathCode;
        break;
    default:break;
    }
    return m_pathCode == pathCode;
}

short RegisterExternalResources::getResourcePathCode()
{
    return m_pathCode;
}
