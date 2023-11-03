Select * from NashvilleHousing order by 1

--Saled date Format

ALTER TABLE NashwilleHousing
Add SaleDateConverted date

Update NashvilleHousing
Set SaleDateConverted = convert(Date, Saledate)

Select SaleDateConverted from  NashvilleHousing

ALTER TABLE NashvilleHousing
Drop Column   Saledate


----------------------------------------------------------------------

--Populate Property Address Date

Select a.ParcelId, a.PropertyAddress ,b.ParcelId , b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
   on a.ParcelID = b.ParcelID
   And a.UniqueID <>  b.UniqueID 
 Where a.PropertyAddress is null

Update a
set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashwilleHousing a
join NashwilleHousing b
   on a.ParcelID = b.ParcelID
   And a.UniqueID <>  b.UniqueID 
Where a.PropertyAddress is null


-------------------------------------------------------------

--Breaking ot Address into Individual Columns(Address , City, State)

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


ALTER TABLE NashvilleHousing
Drop Column PropertyAddress 


Select Owneraddress from  NashvilleHousing


Select 
PARSENAME(Replace(Owneraddress,',','.') , 3),
PARSENAME(Replace(Owneraddress,',','.') , 2),
PARSENAME(Replace(Owneraddress,',','.') , 1)
From NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(Replace(Owneraddress,',','.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(Replace(Owneraddress,',','.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


Update NashvilleHousing
SET OwnerSplitState = PARSENAME(Replace(Owneraddress,',','.') , 1)


ALTER TABLE NashvilleHousing
Drop Column PropertyAddress 

Select * from NashvilleHousing


ALTER TABLE NashvilleHousing
Drop Column OwnerAddress


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2



-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Ord




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


Select SoldAsVacant ,Count(SoldAsVacant) as SoldAsVacantCount
From NashvilleHousing
Group By SoldAsVacant 



-------------------------------------------------

--Remove duplicate

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 SalePrice,
				 SaleDateConverted,
				 PropertySplitAddress,
				 PropertySplitCity,
				 LegalReference
				 ORDER BY
					UniqueID
					)as row_num

From NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertySplitAddress ,  PropertySplitCity
