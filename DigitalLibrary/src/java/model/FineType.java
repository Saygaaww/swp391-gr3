package model;

import java.math.BigDecimal;

/**
 * Loại phạt: late_return, lost, damaged.
 */
public class FineType {
    private int fineTypeId;
    private String name;
    private String description;
    private BigDecimal defaultAmount;
    private BigDecimal perDayRate;

    public FineType() {
    }

    public FineType(String name) {
        this.name = name;
    }

    public FineType(String name, String description, BigDecimal defaultAmount, BigDecimal perDayRate) {
        this.name = name;
        this.description = description;
        this.defaultAmount = defaultAmount;
        this.perDayRate = perDayRate;
    }

    public int getFineTypeId() {
        return fineTypeId;
    }

    public void setFineTypeId(int fineTypeId) {
        this.fineTypeId = fineTypeId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getDefaultAmount() {
        return defaultAmount;
    }

    public void setDefaultAmount(BigDecimal defaultAmount) {
        this.defaultAmount = defaultAmount;
    }

    public BigDecimal getPerDayRate() {
        return perDayRate;
    }

    public void setPerDayRate(BigDecimal perDayRate) {
        this.perDayRate = perDayRate;
    }
}
