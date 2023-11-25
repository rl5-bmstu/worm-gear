import QtQuick 6.2
import QtQuick.Controls 6.2
import LabLatest
import QtQuick3D
import Quick3DAssets.Reductor_cherv
import QtQuick3D.Helpers 6.4
import com.example 1.0
import QtQuick.Layouts 6.3
import QtQuick.Controls
import QtCharts
import QtMultimedia


Rectangle {
    property real  k_load: 1.0;
    property real  k_dvig: 0.13;
    property real k_load_podg: 1.0;
    property real k_dvig_podg: 0.5;
    property real i : (53/31)**6
    property real mass : 3
    property real ind2angl:3.6
    property real ind2sangl:0.36
    property real w:0
    property real kpd: 0

    property real m_load:0
    property real m_dvig:0
    property bool started:false
    property real corr:0
    width: 0
    height: 0
    color: "#303030"




    Item {
        id: __materialLibrary__

        DefaultMaterial {
            id: defaultMaterial
            objectName: "New Material"
        }
    }


    Item {
        x: 1
        y: 64
        width: 190
        height: 105
        scale: 0.6

        Timer {
            id: animTimer
            interval: 10
            running: false
            repeat: true
            onTriggered: {
                if(started){
                    w = electromechanicalSystem.get_w(sliderLoad.value,sliderVoltage.value)
                    kpd = 0.45*electromechanicalSystem.get_kpd(sliderLoad.value,sliderVoltage.value,w)+0.234
                    m_dvig = sliderLoad.value*k_load/(kpd*i*k_dvig_podg*k_dvig)
                    m_load=sliderLoad.value
                }
                else{
                    w = 0
                    kpd =0
                    m_dvig = 0
                    m_load=0
                }
                corr = (m_dvig) %100
                corr = 0.08402*corr-0.021597*Math.pow(corr,2)+0.001024*Math.pow(corr,3)-1.8911/100000*Math.pow(corr,4)+1.5457/10000000*Math.pow(corr,5)-4.71719899/10000000000*Math.pow(corr,6)

                reductor.dvigIndicatorAngle += 0.1*(((-(m_dvig+corr)*ind2angl)-reductor.dvigIndicatorAngle)+0.4*(-(w*360/17) - reductor.tachIndicatorAngle))
                reductor.dvigSmallIndicatorAngle = -reductor.dvigIndicatorAngle/10
                reductor.dvigAngle = reductor.dvigIndicatorAngle/800
                reductor.tachIndicatorAngle += 0.1*(-(w*360/17) - reductor.tachIndicatorAngle)
                reductor.d_deformValue = - reductor.dvigAngle / 2


                corr = (m_load) %100
                corr = 0.084020300500000*Math.pow(corr,1)-0.021597296600000*Math.pow(corr,2)+0.001024123960000*Math.pow(corr,3)-0.000018911627600*Math.pow(corr,4)+0.000000154574671*Math.pow(corr,5)-0.000000000471720*Math.pow(corr,6)

                reductor.nagrIndicatorAngle += 0.1*(-(m_load+corr)*(k_load_podg)*ind2angl-reductor.nagrIndicatorAngle )
                reductor.nagrSmallIndicatorAngle = -reductor.nagrIndicatorAngle/10
                reductor.nagrAngle = -reductor.nagrIndicatorAngle/800
                reductor.n_defomValue = reductor.nagrAngle/2
                reductor.animationAngle =reductor.animationAngle+w
                //print(kpd,m_dvig,w,sliderLoad.value)
                //print(sceneCamera.x ,sceneCamera.y,sceneCamera.z,sceneCamera.eulerRotation.x,sceneCamera.eulerRotation.y)

            }
        }
        Timer {
            id: tarirovkaTimer
            interval: 1000
            running: false
            repeat: true
            onTriggered: {
                animationDvigIndicator.to = - gradDvigSlider.value * mass*ind2angl / (k_dvig* k_dvig_podg)
                animationDvigIndicator.duration = 800
                animationDvigIndicator.running = true
                animationDvigIndicator.from = - gradDvigSlider.value * mass*ind2angl / (k_dvig* k_dvig_podg)

                animationDvigSmallIndicator.to = gradDvigSlider.value * mass*ind2sangl / (k_dvig* k_dvig_podg)
                animationDvigSmallIndicator.duration = 800
                animationDvigSmallIndicator.running = true
                animationDvigSmallIndicator.from = gradDvigSlider.value * mass *ind2sangl / (k_dvig* k_dvig_podg)

                animationNagrIndicator.to = - gradNagrSlider.value * 3*mass*ind2angl / (k_load*k_load_podg)
                animationNagrIndicator.duration = 800
                animationNagrIndicator.running = true
                animationNagrIndicator.from = - gradNagrSlider.value * 3*mass*ind2angl / (k_load*k_load_podg)

                animationNagrSmallIndicator.to = gradNagrSlider.value * 3*mass *ind2sangl/(k_load*k_load_podg)
                animationNagrSmallIndicator.duration = 800
                animationNagrSmallIndicator.running = true
                animationNagrSmallIndicator.from = gradNagrSlider.value * 3*mass *ind2sangl/(k_load*k_load_podg)
                reductor.nagrAngle = gradNagrSlider.value / 12
                reductor.n_defomValue = gradNagrSlider.value / 35

                reductor.dvigAngle = - gradDvigSlider.value / 5
                reductor.d_deformValue = gradDvigSlider.value / 20

            }
        }
        PropertyAnimation { id: animationDvigIndicator;
            easing.type: Easing.OutElastic
            easing.amplitude: 2.0
            easing.period: 1.5
            target: reductor
            property: "dvigIndicatorAngle";
            paused: false
            duration: 0
            alwaysRunToEnd: true
            loops: 1
            running: false
            from: 0;
            to: 360;
        }
        PropertyAnimation { id: animationDvigSmallIndicator;
            easing.type: Easing.OutElastic
            easing.amplitude: 2.0
            easing.period: 1.5
            target: reductor
            property: "dvigSmallIndicatorAngle";
            paused: false
            duration: 0
            alwaysRunToEnd: true
            loops: 1
            running: false
            from: 0;
            to: 360;
        }
        PropertyAnimation { id: animationNagrIndicator;
            easing.type: Easing.OutElastic
            easing.amplitude: 2.0
            easing.period: 1.5
            target: reductor
            property: "nagrIndicatorAngle";
            paused: false
            duration: 0
            alwaysRunToEnd: true
            loops: 1
            running: false
            from: 0;
            to: 360;
        }
        Slider {
            id: sliderVoltage
            x: 519
            y: 49
            width: 800
            height: 48
            stepSize: 0.5
            to: 100
            value: 0
            from: 0
        }

        Slider {
            id: sliderLoad
            signal valueChanged (int value)
            x: 519
            y: -19
            width: 800
            height: 48
            stepSize: 0.5
            to: 100
            from: 0
            value:0


        }

        PropertyAnimation { id: animationNagrSmallIndicator;
            easing.type: Easing.OutElastic
            easing.amplitude: 2.0
            easing.period: 1.5
            target: reductor
            property: "nagrSmallIndicatorAngle";
            paused: false
            duration: 0
            alwaysRunToEnd: true
            loops: 1
            running: false
            from: 0;
            to: 360;
        }
        PropertyAnimation { id: animationReductorAngle;
            easing.type: Easing.Linear
            target: reductor
            property: "animationAngle";
            paused: false
            duration: 0
            alwaysRunToEnd: true
            loops: 0
            running: false
            from: 0;
            to: 360;
        }

        ColumnLayout {
            id: columnLayout
            x: 519
            y: -75
            width: 861
            height: 151
            /*Label {
                            id: labelWDvig
                            text: "wdvig = 0"
                            Layout.preferredWidth: 159
                            Layout.preferredHeight: 29
                        }

                        Label {
                            id: labelMEngine
                            x: 450
                            y: 59
                            text: "M_engine = 0"
                        }*/

            ColumnLayout {
                width: 800
                Label {
                    id: labelSliderLoad
                    width: 800
                    text: qsTr("Изменить момент нагрузки")
                }

                /*Label {
                                id: testLabel
                                text: sliderLoad.value
                            }*/
            }

            ColumnLayout {
                width: 800
                Label {
                    id: labelSliderVoltage
                    text: qsTr("Изменить напряжение")
                }
            }
        }

        PropertyAnimation { id: animationtachIndicatorAngle;
            easing.type: Easing.Linear
            target: reductor
            property: "tachIndicatorAngle";
            paused: false
            duration: 0
            alwaysRunToEnd: true
            loops: 1
            running: false
            from: 0;
            to: 360;
        }



        ColumnLayout {
            id: tarirovkaLayout
            x: 1125
            y: 235
            visible: false
            Switch {
                id: gradModeDvig
                text: qsTr("Вставить градуировочный рычаг в двигатель")
                onToggled: reductor.graduirovkaDvigMode = gradModeDvig.checked
                onReleased: {
                    gradDvigSlider.value = 0
                    reductor.graduirovkaDvigLength = 0
                }
                onCheckedChanged: {
                    if (gradModeDvig.checked) {
                        // Включить таймер
                        gradDvigSlider.enabled = true
                        tarirovkaTimer.running = true
                        tarirovkaTimer.start()

                        animTimer.running = false
                        animTimer.stop()

                    } else {
                        // Выключить таймер
                        gradDvigSlider.enabled = false
                        tarirovkaTimer.running = false
                        tarirovkaTimer.stop()
                        reductor.dvigIndicatorAngle =0
                        reductor.dvigSmallIndicatorAngle =0
                        reductor.dvigAngle = 0
                        reductor.tachIndicatorAngle =0
                        reductor.d_deformValue = 0
                        reductor.animationAngle =0
                        animTimer.running = true
                        animTimer.start()

                    }
                }
            }

            Text {
                id: gradDvigText
                color: "#ffffff"
                text: qsTr("Плечо: 0cм ")
                font.pixelSize: 22
            }

            Slider {
                id: gradDvigSlider
                stepSize: 3
                snapMode: RangeSlider.SnapAlways
                value: 0
                enabled: false
                onValueChanged: {

                    gradDvigText.text = "Плечо: " + gradDvigSlider.value + "см"
                    reductor.graduirovkaDvigLength = gradDvigSlider.value/3
                }
                live: true
                to: 21
            }

            Switch {
                id: gradModeNagr
                text: qsTr("Вставить градуировочный рычаг в нагрузку")
                onToggled: function(){
                    reductor.graduirovkaNagrMode = gradModeNagr.checked
                }
                onCheckedChanged: {
                    if (gradModeNagr.checked) {
                            // Включить таймер
                            gradNagrSlider.enabled = true
                            tarirovkaTimer.running = true
                            tarirovkaTimer.start()
                            animTimer.running = false
                            animTimer.stop()

                        } else {
                            gradNagrSlider.enabled = false
                            // Выключить таймер
                            tarirovkaTimer.running = false
                            tarirovkaTimer.stop()
                            reductor.nagrIndicatorAngle =0
                            reductor.nagrSmallIndicatorAngle = 0
                            reductor.nagrAngle = 0
                            reductor.n_defomValue = 0
                            animTimer.running = true
                            animTimer.start()

                        }
                }
                onReleased: function(){
                    gradNagrSlider.value = 0
                    reductor.graduirovkaNagrLength = 0
                }

            }

            Text {
                id: gradNagrText
                color: "#ffffff"
                text: qsTr("Плечо: 0cм ")
                font.pixelSize: 22
            }

            Slider {
                id: gradNagrSlider
                stepSize: 3
                enabled: false
                snapMode: RangeSlider.SnapAlways
                value: 0
                onValueChanged: {gradNagrText.text = "Плечо: " + gradNagrSlider.value + "см"
                    reductor.graduirovkaNagrLength = gradNagrSlider.value/3
                }
                live: true
                to: 21
            }
        }


        Switch {
            x: 1125
            y: 195
            id: tarirovkaSwitch
            text: qsTr("Перейти в режим градуировки")
            onCheckedChanged: {
                if (tarirovkaSwitch.checked) {
                    tarirovkaLayout.visible = true
                } else {
                    tarirovkaLayout.visible = false
                }
            }

        }

        ElectromechanicalSystem {
            id: electromechanicalSystem
        }

        ColumnLayout {
            x: 91
            y: 0
            ColumnLayout {
                RowLayout {
                    RowLayout {
                        Button {
                            id: button
                            text: "Запустить двигатель"
                            onClicked: function(){
                                started = true
                                animTimer.running = true
                                animTimer.start()
                            }
                        }

                        Button {
                            text: "Остановить двигатель"
                            onClicked: function(){
                                started = false


                            }
                        }
                    }
                }

                ColumnLayout {
                    Layout.preferredWidth: 914
                    x: 0
                    y: 150


                    Text {
                        id: text1
                        text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\nhr { height: 1px; border-width: 0; }\nli.unchecked::marker { content: \"\\2610\"; }\nli.checked::marker { content: \"\\2612\"; }\n</style></head><body style=\" font-family:'Segoe UI'; font-size:9pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:20pt; color:#ffffff;\">Переместить камеру к:</span></p></body></html>"
                        font.pixelSize: 12
                        textFormat: Text.RichText
                    }

                    RowLayout {
                        Button {
                            id: button1
                            text: qsTr("Индикатор тахометра")
                            Connections {
                                target: button1
                                onClicked: {
                                    sceneCamera.x = -643.3109741210938
                                    sceneCamera.y = 144.273193359375
                                    sceneCamera.z = -140.89352416992188
                                    sceneCamera.eulerRotation.x = 0
                                    sceneCamera.eulerRotation.y = -90
                                }
                            }
                        }

                        Button {
                            id: button2
                            text: qsTr("Индикатор момента двигателя")
                            Connections {
                                target: button2
                                onClicked: {

                                    sceneCamera.x = -259.0067138671875
                                    sceneCamera.y = 202.80804443359375
                                    sceneCamera.z = -20.99173927307129
                                    sceneCamera.eulerRotation.x = 0
                                    sceneCamera.eulerRotation.y = 0
                                }
                            }
                        }

                        Button {
                            id: button3
                            text: qsTr("Индикатор момента нагрузки")

                            onClicked: {
                                sceneCamera.x = -108.68628692626953
                                sceneCamera.y = 171.1158905029297
                                sceneCamera.z = 45.371253967285156
                                sceneCamera.eulerRotation.x = -7.672687530517578
                                sceneCamera.eulerRotation.y = -92.16936492919922
                            }
                        }

                        Button {
                            id: button4
                            text: qsTr("Общий вид")
                            onClicked: {
                                sceneCamera.x = -43.01
                                sceneCamera.y = 433.34509
                                sceneCamera.z = 324.28134
                                sceneCamera.eulerRotation.x = -37.310100
                                sceneCamera.eulerRotation.y = 1.1856462955
                            }
                        }

                        Button {
                            id: button5
                            text: qsTr("Редуктор")
                            onClicked: {

                                sceneCamera.x = -94.20280456542969
                                sceneCamera.y = 267.8715515136719
                                sceneCamera.z = -95.01138305664062
                                sceneCamera.eulerRotation.x = -66.0937728881836
                                sceneCamera.eulerRotation.y = -46.8466796875
                            }
                        }
                    }
                    Layout.preferredHeight: 89
                }
            }


        }

        Rectangle {
            id: rectangle
            x: 8
            y: 278
            width: 1100
            height: 700
            visible: true
            color: "#000000"
            radius: 100
            focus: false
            activeFocusOnTab: false
            layer.smooth: false
            smooth: true
        }
        View3D {
            id: view3D
            x: 58
            y: 328
            width: 1000
            height: 600
            activeFocusOnTab: false
            focus: false


            Node {
                id: scene
                PointLight {
                    id: backLight
                    x: 13.058
                    y: 428.835
                    color: "#ffffff"
                    ambientColor: "#343333"
                    z: -170.18332
                    brightness: 50
                }
                PointLight {
                    id: frontLight
                    x: 13.062
                    y: 428.835
                    color: "#ffffff"
                    ambientColor: "#343333"
                    z: 170.18332
                    brightness: 50
                }
                PointLight {
                    id: leftLight
                    x: 577.002
                    y: 428.835
                    color: "#ffffff"
                    ambientColor: "#343333"
                    z: -170.18333
                    brightness: 50
                }
                PointLight {
                    id: rightLight
                    x: -705.184
                    y: 428.835
                    color: "#ffffff"
                    ambientColor: "#343333"
                    z: -170.18333
                    brightness: 50
                }

                PerspectiveCamera {
                    id: sceneCamera
                    x: 31.535
                    y: 130.822
                    z: 155.88931
                }


            }
            environment: sceneEnvironment
            SceneEnvironment {
                id: sceneEnvironment
                backgroundMode: SceneEnvironment.Color
                clearColor: "#cdf3ec"
                antialiasingQuality: SceneEnvironment.Medium
                antialiasingMode: SceneEnvironment.NoAA
            }


            Reductor_cherv {
                id: reductor
                x: -67.028
                y: 0
                n_defomValue: 0.9

                graduirovkaNagrMode: false
                graduirovkaDvigMode: false
                z: -75.33374
                dvigIndicatorAngle: 0
                animationAngle: 4.6
            }
            WasdController {
                id: wasdController
                x: -86
                y: -50
                width: 1149
                height: 699
                speed: 0.1
                controlledObject: sceneCamera
            }



        }









    }

    Label {
        id: label
        x: 832
        y: 94
        width: 77
        height: 32
        visible: false
        text: qsTr("Label")
    }
}

