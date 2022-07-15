Select * from PortfolioProject..NashvilleHousing

--Standardize the date

Select SaleDate, CONVERT(Date,SaleDate) from PortfolioProject..NashvilleHousing

Update NashvilleHousing SET SaleDate=CONVERT(Date,SaleDate)

--Populate Property Address

Select * from PortfolioProject..NashvilleHousing
where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing as a
join PortfolioProject..NashvilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing as a
join PortfolioProject..NashvilleHousing as b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

----------------------------------------------------------------------------------------------------
--Breaking Out address into three columns(Address,city, state)


Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as CIty
from PortfolioProject..NashvilleHousing

Alter table NashvilleHousing 
add PropertySplitAddress Nvarchar(55)

Alter table NashvilleHousing 
add PropertySplitCity Nvarchar(55)

Update NashvilleHousing 
SET PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Update NashvilleHousing 
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))



--------------------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in 'Sold as vacant' field through case satement


Select SoldAsVacant
, CASE when SoldAsVacant='N' then 'No'
       when SoldAsVacant='Y' then 'Yes'
	   Else SoldAsVacant
	   End
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
set
SoldAsVacant=
CASE when SoldAsVacant='N' then 'No'
       when SoldAsVacant='Y' then 'Yes'
	   Else SoldAsVacant
	   End



-------------------------------------------------
--Remove Dublicate

With RowNumCTE as(
Select * 
 , ROW_NUMBER() over(
   partition by ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
				   UniqueID
				   )row_num
from PortfolioProject..NashvilleHousing
)
Select * 
from RowNumCTE
where row_num>1
order by PropertyAddress

Select * from PortfolioProject..NashvilleHousing


-------------------------------------------------

--Delete unused columns

Alter table PortfolioProject..NashvilleHousing
delete column OwnerAddress,TaxDistrict,PropertyAddress



