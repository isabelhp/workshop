#!groovy
@Library('Librerias') _

pipeline {
  agent any
  stages{
    stage("release SIN BASH") {
      steps{
        echo "SIN BASH.........................."
        script {
          def release = readYaml (file: 'release.yml')
          println release.getClass().getName()
          //echo "${release}"

          java_int = release['APP_JAVA-INT']
          echo "La versión de APP_JAVA-INT es: ${java_int}"
          java_pre = release['APP_JAVA-PRE']
          echo "La versión de APP_JAVA-PRE es: ${java_pre}"
          java_pro = release['APP_JAVA-PRO']
          echo "La versión de APP_JAVA-PRO es: ${java_pro}"
        }
      }
    }
    stage("release CON BASH") {
      steps{
        echo "CON BASH.........................."
        
        echo "forma con sh -----"
        sh '''
          echo "La versión de APP_JAVA-INT es:$(grep "APP_JAVA-INT" release.yml | cut -d ":" -f 2)"
          echo "La versión de APP_JAVA-PRE es:$(grep "APP_JAVA-PRE" release.yml | cut -d ":" -f 2)"
          echo "La versión de APP_JAVA-PRO es:$(grep "APP_JAVA-PRO" release.yml | cut -d ":" -f 2)"
        '''
        echo "forma con script -----"
        script{
          def j_int = sh(returnStdout: true, script: """ grep "APP_JAVA-INT" release.yml | cut -d ":" -f 2 """)
          println "La versión de APP_JAVA-INT es:" + j_int
          def j_pre = sh(returnStdout: true, script: """ grep "APP_JAVA-PRE" release.yml | cut -d ":" -f 2 """)
          println "La versión de APP_JAVA-PRE es:" + j_pre
          def j_pro = sh(returnStdout: true, script: """ grep "APP_JAVA-PRO" release.yml | cut -d ":" -f 2 """)
          println "La versión de APP_JAVA-PRO es:" + j_pro
        }
      }
    }

    stage("release SIN BASH y bucle") {
      steps{
        echo "SIN BASH bucle.........................."
        script {
          def release = readYaml (file: 'release.yml')
          //para saber que tipo de variable es
          println release.getClass().getName()
          release.each{k,v->
            println "La versión de " + k + " es: " + v
          } 
        }
      }
    }

    stage("release CON BASH y bucle") {
      steps{
        echo "CON BASH bucle.........................."
        //filas = wc -l release.yml
        //colum = awk '{print NF}' release.yml | sort -nu | tail -n 1
        //v1_int = cut -d ":" -f 1 release.yml | cut -d$'\n' -f 1
        //v2_int= grep $v1_int release.yml | cut -d ":" -f 2

        echo "con while--------------------"
        sh '''
          while read -r line; do
            echo "La version de $(echo "$line" | cut -d ":" -f 1) es:$(echo "$line" | cut -d ":" -f 2)"
          done < release.yml
        '''

        echo "con for----------------------"
        sh '''
          IFS=$'\n'
          for i in $(cat release.yml)
          do
            echo "La version $(echo "$i" | cut -d ":" -f1) es$(echo "$i" | cut -d ":" -f2)"
          done
        '''
      }
    }

    stage("release cambio de valores (SIN BASH)") {
      steps{
        echo "SIN BASH cambio valores.........................."
        script {
          
          def release = readYaml (file: 'release.yml')
          
          //println release
          
          env.KEY = input message: 'Please enter the KEY',
                             parameters: [string(defaultValue: '',
                                          description: '',
                                          name: 'Key')]
          env.VALUE = input message: 'Please enter the VALUE',
                             parameters: [string(defaultValue: '',
                                          description: '',
                                          name: 'Value')]
    
          a=1
          release.each{k,v->
            if (env.KEY == k) {
              a=0
              println "La version de " + k + " era " + v + " y ahora es: " + env.VALUE
            }else{
              println "La version de " + k + " es " + v
            }
          }

          if (a == 1) {
            println "La version de "+ env.KEY + " es " + env.VALUE
          }

          release."${env.KEY}" = env.VALUE
          // tambien se puede usar release.put("APP_JAVA-AUX", "1.1.5")
          writeYaml file: 'release.yml', data: release, overwrite: true
          println release
                   
        }
      }
    }

    stage("release cambio de valores (CON BASH)") {
      steps{
        echo "CON BASH cambio valores.........................."
        script {
          
          def release = readYaml (file: 'release.yml')
          
          println release
          
          env.KEY = input message: 'Please enter the KEY',
                             parameters: [string(defaultValue: '',
                                          description: '',
                                          name: 'Key')]
          env.VALUE = input message: 'Please enter the VALUE',
                             parameters: [string(defaultValue: '',
                                          description: '',
                                          name: 'Value')]
          a=1
          release.each{k,v->
            
            if (env.KEY == k) {
              sh ("`sed -i 's/$k: $v/$env.KEY: $env.VALUE/g' release.yml`")
              def release2 = readYaml (file: 'release.yml')
              println release2
              println "La version de "+ k + " era " + v + " y ahora es: " + env.VALUE
              a=0
            }
          }

          if (a == 1) {
            sh ("""echo "${env.KEY}: ${env.VALUE}" >> release.yml""")
            def release2 = readYaml (file: 'release.yml')
            println release2
            println "La nueva key es "+ env.KEY + " y su key es " + env.VALUE
          }
        }
      }
    }
  }
}



