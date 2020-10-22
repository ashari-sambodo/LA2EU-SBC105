#include "KeyboardOnScreenAdapter.h"
#include <QInputMethodEvent>
#include <QCoreApplication>

///// REGISTER C++ QML TYPE BY IT SELFT, NO NEED CALL qmlRegister from another location
//#include <QtQml/qqml.h>
//#define QML_REGISTER(a) static int unused_val = qmlRegisterType<a>("Cpp.KeyboardOnScreen.Adapter", 1, 0, #a)
//QML_REGISTER(KeyboardOnScreenAdapter);

KeyboardOnScreenAdapter::KeyboardOnScreenAdapter(QObject *parent) : QObject(parent)
{

}

void KeyboardOnScreenAdapter::setFocusItem(QObject *focusItem)
{
    m_focusItem = focusItem;
}

void KeyboardOnScreenAdapter::sendKeyToFocusItem(const QString &keytext)
{
    if(!m_focusItem) return;

    QInputMethodEvent ev;
    if(keytext == QString("\x7F")){
        //delete on char
        ev.setCommitString("",-1,1);
    }else {
        //add character
        ev.setCommitString(keytext);
    }

    qApp->sendEvent(m_focusItem, &ev);
}

void KeyboardOnScreenAdapter::sendBackspaceToFocusItem()
{
    if(!m_focusItem) return;

    QInputMethodEvent ev;
    ev.setCommitString("",-1,1);

    qApp->sendEvent(m_focusItem, &ev);
}
