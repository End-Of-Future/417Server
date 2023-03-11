--风暴巨龙 迦拉克隆
function c88888852.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,88888852+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c88888852.accon)  
	e1:SetTarget(c88888852.actg) 
	e1:SetOperation(c88888852.acop) 
	c:RegisterEffect(e1) 
	--token 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_FZONE)  
	e2:SetCountLimit(1) 
	e2:SetTarget(c88888852.tktg) 
	e2:SetOperation(c88888852.tkop) 
	c:RegisterEffect(e2) 
	c88888852.field_effect=e2 
	--to hand 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH) 
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_LEAVE_FIELD)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetTarget(c88888852.thtg) 
	e3:SetOperation(c88888852.thop) 
	c:RegisterEffect(e3) 
	--to hand 
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_TOHAND) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e4:SetCode(EVENT_SUMMON_SUCCESS) 
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetRange(LOCATION_GRAVE) 
	e4:SetCountLimit(1,18888852+EFFECT_COUNT_CODE_DUEL) 
	e4:SetTarget(c88888852.xthtg) 
	e4:SetOperation(c88888852.xthop) 
	c:RegisterEffect(e4) 
	local e5=e4:Clone() 
	e5:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e5) 
	local e6=e4:Clone() 
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS) 
	c:RegisterEffect(e6) 
end
c88888852.SetCard_A_jlcl=true 
function c88888852.ackfil(c) 
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) 
end 
function c88888852.accon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c88888852.ackfil,tp,LOCATION_MZONE,0,1,nil) 
end  
function c88888852.actg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end   
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888852,5))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888852,5))
end 
function c88888852.acop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if Duel.IsPlayerCanSpecialSummonMonster(tp,88888853,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_THUNDER,ATTRIBUTE_WIND,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(88888852,0)) then 
	local token=Duel.CreateToken(tp,88888853)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK) 
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE) 
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetValue(1)
	token:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(function(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION end)
	token:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token:RegisterEffect(e9)
	if Duel.IsPlayerCanSpecialSummonMonster(tp,88888853,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_THUNDER,ATTRIBUTE_WIND,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,88888852)~=0 and Duel.SelectYesNo(tp,aux.Stringid(88888852,1)) then 
	local token=Duel.CreateToken(tp,88888853)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK) 
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE) 
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetValue(1)
	token:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(function(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION end)
	token:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token:RegisterEffect(e9)
	end 
	end 
end 
function c88888852.tktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,88888853,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_THUNDER,ATTRIBUTE_WIND,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end   
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888852,6))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888852,6))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0) 
end 
function c88888852.tkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsPlayerCanSpecialSummonMonster(tp,88888853,0,TYPES_TOKEN_MONSTER,2000,2000,10,RACE_THUNDER,ATTRIBUTE_WIND,POS_FACEUP_ATTACK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local token=Duel.CreateToken(tp,88888853)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK) 
	--cannot release
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetRange(LOCATION_MZONE) 
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	e5:SetValue(1)
	token:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e7:SetValue(function(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION end)
	token:RegisterEffect(e7)
	local e8=e5:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token:RegisterEffect(e8)
	local e9=e5:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	token:RegisterEffect(e9)
	end 
	Duel.RegisterFlagEffect(tp,88888852,RESET_PHASE+PHASE_END,0,1)  
end 
function c88888852.thfil(c) 
	return c:IsRace(RACE_DRAGON) and c:IsAbleToHand()  
end 
function c88888852.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c88888852.thfil,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(88888852,7))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(88888852,7))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_EXTRA) 
end  
function c88888852.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c88888852.thfil,tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_EXTRA,0,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SendtoHand(sg,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,sg) 
	end 
end
function c88888852.xthtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0) 
end  
function c88888852.xthop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoHand(c,nil,REASON_EFFECT) 
	end 
end 




