#include "KeyboardOnScreenCaller.h"

KeyboardOnScreenCaller::KeyboardOnScreenCaller(QObject *parent) : QObject(parent)
{

}

void KeyboardOnScreenCaller::openKeyboard(QObject *targetTextInput, QString title)
{
    m_targetTextInput = targetTextInput;
    m_title = title;
    emit openKeyboardRequested();
}

void KeyboardOnScreenCaller::openNumpad(QObject *targetTextInput, QString title)
{
    m_targetTextInput = targetTextInput;
    m_title = title;
    emit openNumpadRequested();
}

QString KeyboardOnScreenCaller::title() const
{
    return m_title;
}

QObject *KeyboardOnScreenCaller::targetTextInput() const
{
    return m_targetTextInput;
}
