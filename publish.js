const fs = require('fs');
const child = require("child_process");

var newVersion = process.argv.slice(2)[0];
let posspecFilePath = 'CooeeSDK.podspec';
let podspecData = fs.readFileSync(posspecFilePath, "utf8");
let oldVersion = podspecData.match(/spec.version      = "[^"]+"/)[0].split('=')[1].trim().replaceAll('"', '');
let versionFilePath = 'CooeeSDK/utils/Constants.swift';

if (!newVersion) {
    console.log('Please specify a version number/updater');
    return;
}

if (newVersion === 'patch') {
    newVersion = updatePatch(oldVersion);
} else if (newVersion === 'minor') {
    newVersion = updateMinor(oldVersion);
} else if (newVersion === 'major') {
    newVersion = updateMajor(oldVersion);
} else if (!isValidVersion(newVersion)) {
    console.log('Please specify a valid version number/updater');
    console.log('node publish.js patch|minor|major|version');
    console.log('parameter:\n' +
        '\tpatch: update patch version i.e 1.0.0 -> 1.0.1\n' +
        '\tminor: update minor version i.e 1.0.0 -> 1.1.0\n' +
        '\tmajor: update major version i.e 1.0.0 -> 2.0.0\n' +
        '\tversion: valid version string in 1.1.1 format\n');
    return;
}

function isValidVersion(version) {
    return /^\d+\.\d+\.\d+$/.test(version);
}

console.log(`updating [${oldVersion}] --> [${newVersion}]`);

podspecData = podspecData.replace(/spec.version      = "[^"]+"/, `spec.version      = "${newVersion}"`);
fs.writeFileSync(posspecFilePath, podspecData);

let cooeeMetaData = fs.readFileSync(versionFilePath, "utf8");
cooeeMetaData = cooeeMetaData.replace(/VERSION_STRING = "[^"]+"/, `VERSION_STRING = "${newVersion}"`);
fs.writeFileSync(versionFilePath, cooeeMetaData);

pushCodeAndPublishPod();

/**
 * Run terminal command to push code, tag & publish pod
 */
function pushCodeAndPublishPod() {
    console.log('************ Pushing CooeeSDK ************');

    var child = require('child_process')//.exec('gpush')
    child.exec('git add CooeeSDK/utils/Constants.swift CooeeSDK.podspec CHANGELOG.md &&' +
        ` git commit -m "release:v${newVersion}" &&` +
        ` git tag ${newVersion} &&` +
        ' git push origin main &&' +
        ' git push gh main &&' +
        ' git push origin --tags &&' +
        ' git push gh --tags &&' +
        ' pod trunk push CooeeSDK.podspec', function (error, stdout, stderr) {
        console.log('stdout: ' + stdout);
        console.log('stderr: ' + stderr);
        if (error !== null) {
            console.log('exec error: ' + error);
        }
    });
}

/**
 * Update patch version
 *
 * @param oldVersion {string} old version string
 * @returns {string} new version string
 */
function updatePatch(oldVersion) {
    let oldVersionArr = oldVersion.split('.');
    let newVersionArr = oldVersionArr.slice();
    newVersionArr[2] = parseInt(newVersionArr[2]) + 1;
    return newVersionArr.join('.');
}

/**
 * Update minor version
 *
 * @param oldVersion {string} old version string
 * @returns {string} new version string
 */
function updateMinor(oldVersion) {
    let oldVersionArr = oldVersion.split('.');
    let newVersionArr = oldVersionArr.slice();
    newVersionArr[1] = parseInt(newVersionArr[1]) + 1;
    newVersionArr[2] = 0;
    return newVersionArr.join('.');
}

/**
 * Update major version
 *
 * @param oldVersion {string} old version string
 * @returns {string} new version string
 */
function updateMajor(oldVersion) {
    let oldVersionArr = oldVersion.split('.');
    let newVersionArr = oldVersionArr.slice();
    newVersionArr[0] = parseInt(newVersionArr[0]) + 1;
    newVersionArr[1] = 0;
    newVersionArr[2] = 0;
    return newVersionArr.join('.');
}