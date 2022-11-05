import React, { useEffect, useState } from "react";

export const CertificateSettingComponent = ({ setting, setSetting }) => {
  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
      }}
    >
      <h6>certificate</h6>
      <p>{setting.cert.certificate}</p>
    </div>
  );
};
