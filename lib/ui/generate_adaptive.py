"""
Generates an adaptive class.

Javascript for generating input to program:
var acc = '';
var params = document.querySelectorAll('.constructor-summary-list .signature')[0];
for (const item of params.children) {
    acc += item.innerText + '\n';
}
console.log(acc);
"""

import fileinput


def input_constructor():
    """Processes lines of pasted constructor."""
    res = []
    for line in fileinput.input():
        res.append(line.rstrip().rstrip(','))
    return list(filter(lambda x: x != '', res))


class Param:
    """Stores param of constructor."""
    name = ''
    param_type = ''
    required = False
    default = None

    def __init__(self, line):
        """Parse each line to param instance variables."""
        if "@required" in line:
            self.required = True
            line = line.replace('@required ', '')
        if ':' in line:
            self.default = line.split(':')[1].strip()
        space_split = line.split(' ')
        self.param_type = space_split[0]
        self.name = space_split[1].split(':')[0]

    def getType(self):
        return self.param_type

    def hasDefault(self):
        return self.default is not None

    def getDefault(self):
        return self.default

    def getName(self):
        return self.name

    def generateFinalLine(self):
        return 'final ' + self.param_type + ' ' + self.name + ';'

    def generateConstructorPortion(self, generateDefault=True):
        f = ''
        if self.required:
            f = '@required '
        f += 'this.' + self.name
        if self.default and generateDefault:
            f += ':' + self.default
        return f


def process_constructor_list(lst):
    """Process and adds each constructor param into a dict."""
    d = {}
    for line in lst:
        p = Param(line)
        d[p.getName()] = p
    return d


# Name of class
name = input("Class name: ")

print("Input android: ")
android_processed = process_constructor_list(input_constructor())

print("Input cupertino: ")
cupertino_processed = process_constructor_list(input_constructor())


def generateDataClass(constructor_dict, platform):
    end = []

    # class A {
    end.append('class Adaptive' + platform + name + 'Data' + ' {')

    # Instance variable declarations - lines of final Type var;
    for param in constructor_dict.values():
        end.append(param.generateFinalLine())

    # Constructor - A({ @required this.x, this.y : z })
    end.append('')
    end.append('Adaptive' + platform + name + 'Data' + '({')
    params = []
    for param in constructor_dict.values():
        params.append(param.generateConstructorPortion(generateDefault=False))
    end.append(','.join(params))
    end.append('});')

    # }
    end.append('}')
    return '\n'.join(end)


def generateJoined(android_dict, cupertino_dict, androidExtend,
                   cupertinoExtend, common):
    """Generates joined class."""
    res = []
    res.append('class Adaptive' + name +
               ' extends AdaptiveBase<%s, %s> {' % (androidExtend,
                                                    cupertinoExtend))

    # Instance variables for data
    res.append('final AdaptiveAndroid' + name + 'Data androidData;')
    res.append('final AdaptiveCupertino' + name + 'Data cupertinoData;')

    # androidData, cupertinoData
    params = []
    params.append('this.androidData')
    params.append('this.cupertinoData')

    # Add final lines + constructor portion for each param
    for param in common:
        res.append(android_dict[param].generateFinalLine())
        params.append(android_dict[param].generateConstructorPortion())

    # Constructor
    res.append('')
    res.append('Adaptive' + name + '({')
    res.append(','.join(params))
    res.append('});')

    return '\n'.join(res)


def generateCreateWidgetFunction(platform, extendName, platform_dict, common):
    """Generate createPlatformWidget function."""
    res = []
    res.append('%s create%sWidget(BuildContext context) {' % (
        extendName, platform))
    res.append('return %s(' % (extendName))

    platformDataName = ''
    if platform == 'Android':
        platformDataName = 'androidData'
    else:
        platformDataName = 'cupertinoData'

    # Add line for each param
    # e.g. x: androidData?.x ?? x ?? DEFAULT,
    for paramName in platform_dict.keys():
        acc = ''
        if paramName in common:
            acc = '%s: %s?.%s ?? %s' % (
                paramName, platformDataName, paramName, paramName)
        else:
            acc = '%s: %s?.%s' % (paramName, platformDataName, paramName)
        if platform_dict[paramName].hasDefault():
            acc += " ?? " + platform_dict[paramName].getDefault()
        acc += ','
        res.append(acc)

    res.append(');')
    res.append('}')
    return '\n'.join(res)


res = []

res.append('import \'package:flutter/material.dart\';')
res.append('import \'package:flutter/cupertino.dart\';')
res.append('import \'./adaptive.dart\';')

res.append('')
res.append(generateDataClass(android_processed, 'Android'))
res.append('')
res.append(generateDataClass(cupertino_processed, 'Cupertino'))
res.append('')

androidExtend = input("Base android class: ")
cupertinoExtend = input("Base cupertino class: ")
print('-' * 50)

# List of common parameters
common = []
for key in android_processed.keys():
    if key in cupertino_processed and android_processed[key].getType() \
            == cupertino_processed[key].getType():
        common.append(key)

# Generate joined class
res.append(generateJoined(android_processed, cupertino_processed,
                          androidExtend, cupertinoExtend, common))
res.append('')
# Generate android create widget function
res.append(generateCreateWidgetFunction(
    'Android', androidExtend, android_processed, common))
res.append('')
# Generate iOS create widget function
res.append(generateCreateWidgetFunction(
    'Cupertino', cupertinoExtend, cupertino_processed, common))
# End joined class
res.append('}')

print('\n'.join(res))
