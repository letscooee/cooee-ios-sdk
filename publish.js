const fs = require('fs');
const child = require("child_process");

let newVersion = process.argv[2];
const podspecFilePath = 'CooeeSDK.podspec';
let podspecData = fs.readFileSync(podspecFilePath, "utf8");
const oldVersion = podspecData.match(/spec.version      = "[^"]+"/)[0].split('=')[1].trim().replaceAll('"', '');
const versionFilePath = 'CooeeSDK/utils/Constants.swift';
const githubOrigin = 'git@github.com:letscooee/cooee-ios-sdk.git';

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
    console.log('Please specify a valid argument - patch|minor|major|<version>');
    console.log('Check:\n\tnode publish.js patch|minor|major|<version>');
    console.log('parameter:\n' +
        '\tpatch: update patch version i.e 1.0.0 -> 1.0.1\n' +
        '\tminor: update minor version i.e 1.0.0 -> 1.1.0\n' +
        '\tmajor: update major version i.e 1.0.0 -> 2.0.0\n' +
        '\t<version>: valid version string in 1.1.1 format\n');
    return;
}

console.log(`updating [${oldVersion}] --> [${newVersion}]`);

podspecData = podspecData.replace(/spec.version      = "[^"]+"/, `spec.version      = "${newVersion}"`);
fs.writeFileSync(podspecFilePath, podspecData);

let cooeeMetaData = fs.readFileSync(versionFilePath, "utf8");
cooeeMetaData = cooeeMetaData.replace(/VERSION_STRING = "[^"]+"/, `VERSION_STRING = "${newVersion}"`);
fs.writeFileSync(versionFilePath, cooeeMetaData);

// Stop here to prevent further process which requires permission for push operation
return;
pushCodeAndPublishPod();

/****************** private functions ******************/

/**
 * Check if the version string is valid
 * @param version {string} version string
 * @returns {boolean} true if valid, false otherwise
 */
function isValidVersion(version) {
    return /^\d+\.\d+\.\d+$/.test(version);
}

/**
 * Run terminal command to push code, tag & publish pod
 */
function pushCodeAndPublishPod() {
    console.log('************ Pushing CooeeSDK ************');

    var child = require('child_process')
    child.exec(`git remote add gh ${githubOrigin}` +
        ` git add ${versionFilePath} ${podspecFilePath} CHANGELOG.md &&` +
        ` git commit -m "release:v${newVersion}" &&` +
        ` git tag ${newVersion} &&` +
        ' git push origin main &&' +
        ' git push gh main &&' +
        ` git push origin ${newVersion} &&` +
        ` git push gh ${newVersion} &&` +
        ' pod trunk push CooeeSDK.podspec', function (error, stdout, stderr) {
        if (stdout !== null) {
            console.log('stdout: ' + stdout);
        } else if (stderr !== null) {
            console.log('stderr: ' + stderr);
        } else if (error !== null) {
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
    let newVersionArr = oldVersion.split('.');
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
    let newVersionArr = oldVersion.split('.');
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
    let majorVersion = oldVersion.split('.')[0];
    majorVersion = parseInt(majorVersion) + 1;
    return `${majorVersion}.0.0`;
}