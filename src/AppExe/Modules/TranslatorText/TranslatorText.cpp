#include <QCoreApplication> /// required when we need to access global object qApp
#include <QQmlEngine>
#include <QtDebug>
#include "TranslatorText.h"

TranslatorText::TranslatorText(QQmlEngine *qmlEngine, QObject *parent) : QObject(parent)
{
    //    Q_UNUSED(qmlEngine);
    m_pTranslator = new QTranslator(this);
    m_pQmlEngine = qmlEngine;
}

void TranslatorText::selectLanguage(const QString code)
{
    bool changed = false;
    if(code == QLatin1String("en")){ /// https://wiki.qt.io/Using_QString_Effectively, QLatin1String : Avoid hidden mallocs in operator "=="
        changed = qApp->removeTranslator(m_pTranslator);
        /// since Qt 5.10, to ensure the text on the View is used the current translation
        if (changed) m_pQmlEngine->retranslate(); /// generated issue binding loop, solving by edit the viewApp
    }
    else {
        bool loaded = m_pTranslator->load(QString(":/i18n/translating-qml_%1").arg(code));
        if(loaded){
            changed  = qApp->installTranslator(m_pTranslator);
            /// since Qt 5.10, to ensure the text on the View is used the current translation
            if (changed) m_pQmlEngine->retranslate(); /// generated issue binding loop, solving by edit the viewApp
        }else{
            qWarning() << __FUNCTION__ << "Failed to load translation" << code;
        }
    }
    emit languageChanged(changed);
}
