#pragma once

#include <QObject>

class KeyboardOnScreenAdapter : public QObject
{
    Q_OBJECT
public:
    explicit KeyboardOnScreenAdapter(QObject *parent = nullptr);

signals:

public slots:
    void setFocusItem(QObject *focusItem);
    void sendKeyToFocusItem(const QString &keytext);
    void sendBackspaceToFocusItem();

private:
    QObject * m_focusItem;

};

