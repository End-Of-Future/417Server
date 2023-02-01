--圣光飞龙的灵魂
function c27819002.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e1:SetCountLimit(1,27819002)
	e1:SetTarget(c27819002.lvtg)
	e1:SetOperation(c27819002.lvop)
	c:RegisterEffect(e1) 
	--search 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,17819002)
	e2:SetTarget(c27819002.srtg)
	e2:SetOperation(c27819002.srop)
	c:RegisterEffect(e2) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,37819002)
	e2:SetCondition(c27819002.spcon)
	e2:SetTarget(c27819002.sptg)
	e2:SetOperation(c27819002.spop)
	c:RegisterEffect(e2)
end
c27819002.SetCard_XXLight=true 
c27819002.SetCard_XXLightDragon=true 
function c27819002.filter(c)
	return c:IsFaceup() and c:GetLevel()>0 and not c:IsLevel(1) 
end
function c27819002.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c27819002.filter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c27819002.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c27819002.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c27819002.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end 
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c27819002.srfilter(c)
	return c.SetCard_XXLight and (c:IsAbleToHand() or c:IsDestructable()) 
end
function c27819002.srop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,3)
	local g=Duel.GetDecktopGroup(p,3)
	if g:GetCount()>0 and g:IsExists(c27819002.srfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(27819002,0)) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local tc=g:FilterSelect(p,c27819002.srfilter,1,1,nil):GetFirst() 
		local op=0 
		if tc:IsAbleToHand() and tc:IsDestructable() then 
		op=Duel.SelectOption(p,aux.Stringid(27819002,1),aux.Stringid(27819002,2)) 
		elseif tc:IsAbleToHand() then 
		op=Duel.SelectOption(p,aux.Stringid(27819002,1)) 
		elseif tc:IsDestructable() then 
		op=Duel.SelectOption(p,aux.Stringid(27819002,2))+1  
		else return end 
		if op==0 then 
		Duel.SendtoHand(tc,nil,REASON_EFFECT) 
		Duel.ConfirmCards(1-p,tc) 
		Duel.ShuffleHand(p) 
		else 
		Duel.Destroy(tc,REASON_EFFECT) 
		end 
	end
	Duel.ShuffleDeck(p)
end
function c27819002.cfilter(c,tp)
	return c:IsFaceup() and c.SetCard_XXLightDragon  
end
function c27819002.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27819002.cfilter,1,nil,tp)
end
function c27819002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c27819002.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end





