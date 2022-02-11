#pragma once

#include <QObject>

class KeyboardOnScreenCaller : public QObject
{
    Q_OBJECT
public:
    explicit KeyboardOnScreenCaller(QObject *parent = nullptr);

    Q_INVOKABLE QObject *targetTextInput() const;
    Q_INVOKABLE QString title() const;

public slots:
    void openKeyboard(QObject* targetTextInput, QString title);
    void openNumpad(QObject* targetTextInput, QString title);

signals:
    void openKeyboardRequested();
    void openNumpadRequested();

private:
    QObject *m_targetTextInput;
    QString m_title;
};

