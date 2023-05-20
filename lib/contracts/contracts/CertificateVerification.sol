// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract CertificateVerification is Ownable {
    struct Certificate {
        string hash;
        uint256 timestamp;
        bool isRevoked;
    }

    mapping(string => mapping(string => Certificate[])) public certificates;

    event CertificateAdded(
        string indexed studentEmailHash,
        string indexed orgEmailHash,
        string certHash
    );
    event CertificateRevoked(
        string indexed studentEmailHash,
        string indexed orgEmailHash,
        string certHash
    );

    function addCertificate(
        string memory studentEmailHash,
        string memory orgEmailHash,
        string memory certHash
    ) public onlyOwner {
        certificates[studentEmailHash][orgEmailHash].push(
            Certificate(certHash, block.timestamp, false)
        );
        emit CertificateAdded(studentEmailHash, orgEmailHash, certHash);
    }

    function revokeCertificate(
        string memory studentEmailHash,
        string memory orgEmailHash,
        string memory certHash
    ) public onlyOwner {
        Certificate[] storage certs = certificates[studentEmailHash][
            orgEmailHash
        ];
        for (uint256 i = 0; i < certs.length; i++) {
            if (
                keccak256(abi.encodePacked(certs[i].hash)) ==
                keccak256(abi.encodePacked(certHash))
            ) {
                require(!certs[i].isRevoked, "Certificate already revoked");
                certs[i].isRevoked = true;
                emit CertificateRevoked(
                    studentEmailHash,
                    orgEmailHash,
                    certHash
                );
                return;
            }
        }
        revert("Certificate not found");
    }

    function verifyCertificate(
        string memory studentEmailHash,
        string memory orgEmailHash,
        string memory certHash
    ) public view returns (bool) {
        Certificate[] memory certs = certificates[studentEmailHash][
            orgEmailHash
        ];
        for (uint256 i = 0; i < certs.length; i++) {
            if (
                keccak256(abi.encodePacked(certs[i].hash)) ==
                keccak256(abi.encodePacked(certHash)) &&
                !certs[i].isRevoked
            ) {
                return true;
            }
        }
        return false;
    }

    function getCertificates(
        string memory studentEmailHash,
        string memory orgEmailHash
    ) public view returns (Certificate[] memory) {
        return certificates[studentEmailHash][orgEmailHash];
    }
}
