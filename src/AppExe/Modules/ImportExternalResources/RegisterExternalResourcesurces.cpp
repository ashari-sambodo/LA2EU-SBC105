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
